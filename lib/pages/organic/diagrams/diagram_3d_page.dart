import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/internet/api/api.dart';
import 'package:quimify_client/internet/internet.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_mascot_message.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Diagram3DPage extends StatefulWidget {
  const Diagram3DPage({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  State<Diagram3DPage> createState() => _Diagram3DPageState();
}

enum _Result {
  successful,
  noInternet,
  unsupportedBrowser,
  error,
}

class _Diagram3DPageState extends State<Diagram3DPage> {
  final WebViewController _controller = WebViewController();

  _Result? _result;
  bool _pageError = false;

  bool _firstBuild = true;
  late bool _lightMode;
  late Color _fromBackground, _toBackground;

  @override
  void initState() {
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) => request.url == widget.url
              ? NavigationDecision.navigate
              : NavigationDecision.prevent,
          onWebResourceError: (error) {
            _pageError = true;
            _onPageError(error);
          },
          onPageFinished: (_) {
            if (_pageError) return;
            _onPageFinished();
          },
        ),
      );

    _loadPage();
    super.initState();
  }

  _loadPage() async {
    await _controller.clearCache(); // Or else half-loaded pages will be shown
    _controller.loadRequest(Uri.parse(widget.url));
  }

  _reloadPage() {
    setState(() {
      _result = null;
      _pageError = false;
      _firstBuild = true;
    });

    _loadPage();
  }

  // WebView will some times call both _onPageError and _onPageFinished

  _onPageError(WebResourceError error) async {
    if (_result != null) return;

    bool disconnected = error.description == 'net::ERR_INTERNET_DISCONNECTED';
    bool hasInternet = disconnected ? false : await hasInternetConnection();

    if (hasInternet) {
      Api().sendError(
        context: 'WebView error',
        details: 'URL "${widget.url}", device info "${await _deviceInfo()}", '
            'error "${error.description}"',
      );
    }

    if (!mounted) return; // For security reasons
    setState(() {
      _result = hasInternet ? _Result.error : _Result.noInternet;
    });
  }

  _onPageFinished() async {
    if (_result != null) return;

    _Result result;

    try {
      result = await _adaptPage();

      if (result == _Result.error) {
        if (await hasInternetConnection()) {
          Api().sendError(
            context: 'WebView adapt page failed',
            details: 'URL "${widget.url}", '
                'device info "${await _deviceInfo()}"',
          );
        } else {
          result = _Result.noInternet;
        }
      }
    } catch (error) {
      result = _Result.error;

      Api().sendError(
        context: 'WebView adapt page crashed',
        details: 'URL "${widget.url}", device info "${await _deviceInfo()}", '
            'error "$error"',
      );
    }

    if (!mounted) return; // For security reasons
    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_firstBuild) {
      // WebView's brightness mode can't be real-time
      Brightness platformBrightness = MediaQuery.of(context).platformBrightness;
      _lightMode = platformBrightness == Brightness.light;

      _fromBackground = _lightMode ? Colors.white : Colors.black;
      _toBackground = QuimifyColors.background(context);
    }

    List<double> backgroundFilter = _lightMode
        ? [
            _toBackground.red / _fromBackground.red, 0, 0, 0, 0,
            0, _toBackground.green / _fromBackground.green, 0, 0, 0,
            0, 0, _toBackground.blue / _fromBackground.blue, 0, 0,
            0, 0, 0, 1, 0, // fromBackground -> toBackground, lineally
          ]
        : [
            1, 0, 0, 0, _toBackground.red.toDouble(),
            0, 1, 0, 0, _toBackground.green.toDouble(),
            0, 0, 1, 0, _toBackground.blue.toDouble(),
            0, 0, 0, 1, 0, // fromBackground -> toBackground, not dividing by 0
          ];

    const String errorTitle = '¡Ups! No se ha podido cargar';
    final Map<_Result, QuimifyMascotMessage> resultToQuimifyMascot = {
      _Result.noInternet: QuimifyMascotMessage(
        tone: QuimifyMascotTone.negative,
        title: errorTitle,
        details: 'Parece que no hay conexión a Internet.',
        buttonLabel: 'Reintentar',
        onButtonPressed: _reloadPage,
      ),
      _Result.unsupportedBrowser: QuimifyMascotMessage.withoutButton(
        tone: QuimifyMascotTone.negative,
        title: errorTitle,
        details: 'Puede que este dispositivo sea demasiado antiguo.',
      ),
      _Result.error: QuimifyMascotMessage(
        tone: QuimifyMascotTone.negative,
        title: errorTitle,
        details: 'Puedes probar a intentarlo otra vez.',
        buttonLabel: 'Reintentar',
        onButtonPressed: _reloadPage,
      ),
    };

    return QuimifyScaffold.noAd(
      header: const QuimifyPageBar(title: 'Estructura 3D'),
      body: Stack(
        children: [
          if (_result == null || _result == _Result.successful)
            ColorFiltered(
              colorFilter: ColorFilter.matrix(backgroundFilter),
              child: WebViewWidget(
                controller: _controller,
              ),
            ),
          if (_result == null)
            Container(
              color: QuimifyColors.background(context),
              child: Center(
                child: CircularProgressIndicator(
                  color: QuimifyColors.teal(),
                ),
              ),
            ),
          if (_result != null && _result != _Result.successful)
            // Column is needed
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: resultToQuimifyMascot[_result]!,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<_Result> _adaptPage() async {
    if (await _checkUnsupportedBrowser()) {
      return _Result.unsupportedBrowser;
    }

    Duration webViewRefreshDelay = const Duration(seconds: 1); // TODO lower?
    Duration checkReadyLoopDelay = const Duration(milliseconds: 100);

    for (int i = 0; i < 10; i++) {
      if (await _checkReadyWebPage()) {
        await _runZoomOutMolecule();
        await _runFocusOnMolecule();

        await Future.delayed(webViewRefreshDelay);
        return _Result.successful;
      }

      await Future.delayed(checkReadyLoopDelay);
    }

    return _Result.error;
  }

  Future<bool> _checkUnsupportedBrowser() async {
    String text = 'Apologies, we no longer support your browser...';

    String innerText = await _controller.runJavaScriptReturningResult('''
      document.body.innerText
    ''') as String;

    return innerText.contains(text);
  }

  Future<bool> _checkReadyWebPage() async {
    String moleculeSelector = 'canvas.cursor-hand';

    Object molecule = await _controller.runJavaScriptReturningResult('''
      document.querySelector('$moleculeSelector') !== null
    ''');

    return molecule == true;
  }

  _runZoomOutMolecule() async {
    String zoomOutButtonSelector = 'button.pc-gray-button[title="Zoom out"]';
    int zoomOutTotalClicks = 6;

    await _controller.runJavaScript('''
      const zoomOutButton = document.querySelector('$zoomOutButtonSelector');
        
      for (let i = 0; i < $zoomOutTotalClicks; i++) {
        setTimeout(function() {
          zoomOutButton.click();
        }, 0);
      }
    ''');
  }

  _runFocusOnMolecule() async {
    String moleculeSelector = 'canvas.cursor-hand';

    await _controller.runJavaScript('''
      const molecule = document.querySelector('$moleculeSelector');
        
      molecule.style.height = '100vh';
        
      document.body.innerHTML = '';
      document.body.appendChild(molecule); 
    ''');
  }

  Future<String> _deviceInfo() async =>
      (await DeviceInfoPlugin().deviceInfo).data.toString();
}
