import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/internet/api/api.dart';
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

  bool _firstBuild = true;
  late bool _lightMode;

  @override
  void initState() {
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (_) => NavigationDecision.prevent,
          onPageFinished: (_) => _onPageFinished(),
          onWebResourceError: (WebResourceError error) => _onPageError(error),
        ),
      );

    _loadPage();
    super.initState();
  }

  _loadPage() async {
    await _controller.clearCache(); // Important
    _controller.loadRequest(Uri.parse(widget.url));
  }

  _reloadPage() {
    setState(() {
      _result = null;
    });

    _loadPage();
  }

  // Both finished and error can be called, with error preceding finished:

  _onPageFinished() async {
    if (_result != null) return;

    if (await _checkUnsupportedBrowser()) {
      _onUnsupportedBrowser();
      return;
    }

    bool adaptedSuccessfully = await _adaptWebPage();

    if (adaptedSuccessfully) {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return; // For security reasons

      setState(() {
        _result = _Result.successful;
      });
    } else {
      setState(() {
        _result = _Result.error;
      });
    }
  }

  _onPageError(WebResourceError error) async {
    if (!mounted) return; // For security reasons

    if (error.description == 'net::ERR_INTERNET_DISCONNECTED') {
      setState(() {
        _result = _Result.noInternet;
      });
    } else {
      setState(() {
        _result = _Result.error;
      });
    }

    Api().sendError(
      context: 'WebView error',
      details: 'URL "${widget.url}", error "${error.description}"',
    );
  }

  _onUnsupportedBrowser() async {
    String device = (await DeviceInfoPlugin().deviceInfo).data['product'];

    Api().sendError(
      context: 'Unsupported browser',
      details: 'URL "${widget.url}", device "$device"',
    );

    if (!mounted) return; // For security reasons

    setState(() {
      _result = _Result.unsupportedBrowser;
    });
  }

  @override
  Widget build(BuildContext context) {
    _fixBrightnessMode(); // WebView's brightness mode is not real-time

    Color fromBackground = _lightMode ? Colors.white : Colors.black;
    Color toBackground = QuimifyColors.background(context);
    List<double> backgroundFilter = _lightMode
        ? [
            toBackground.red / fromBackground.red, 0, 0, 0, 0,
            0, toBackground.green / fromBackground.green, 0, 0, 0,
            0, 0, toBackground.blue / fromBackground.blue, 0, 0,
            0, 0, 0, 1, 0, // fromBackground -> toBackground, lineally
          ]
        : [
            1, 0, 0, 0, toBackground.red.toDouble(),
            0, 1, 0, 0, toBackground.green.toDouble(),
            0, 0, 1, 0, toBackground.blue.toDouble(),
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

  Future<bool> _adaptWebPage() async {
    try {
      await _defineWaitForElement();

      try {
        await _runZoomOutMolecule();
      } catch (nonCriticalError) {
        Api().sendError(
          context: 'Molecule zoom out error',
          details: nonCriticalError.toString(),
        );
      }

      return await _runFocusOnMolecule();
    } catch (error) {
      Api().sendError(
        context: 'Adapting webpage error',
        details: error.toString(),
      );
      return false;
    }
  }

  Future<bool> _runZoomOutMolecule() async {
    String zoomOutButtonSelector = 'button.pc-gray-button[title="Zoom out"]';
    int zoomOutTotalClicks = 6;

    Object zoomOutResult = await _controller.runJavaScriptReturningResult('''
      async function zoomOutMolecule() {
        const zoomOutButton = await waitForElement('$zoomOutButtonSelector');
        
        for (let i = 0; i < $zoomOutTotalClicks; i++) {
          setTimeout(function() {
            zoomOutButton.click();
          }, 0);
        }
      }
      
      zoomOutMolecule();
    ''');

    // Success is NOT guaranteed even if focusResult == '{}'

    if (zoomOutResult != '{}') {
      Api().sendError(
        context: 'Zoom out result NOT {}',
        details: 'Result "${zoomOutResult.toString()}"',
      );
      return false;
    }

    return true;
  }

  Future<bool> _runFocusOnMolecule() async {
    String moleculeSelector = 'canvas.cursor-hand';

    Object focusResult = await _controller.runJavaScriptReturningResult('''
      async function focusOnMolecule() {
        const molecule = await waitForElement('$moleculeSelector');
        
        molecule.style.height = '100vh';
        
        document.body.innerHTML = '';
        document.body.appendChild(molecule); 
      }
      
      focusOnMolecule();
    ''');

    // Success is NOT guaranteed even if focusResult == '{}'

    if (focusResult != '{}') {
      Api().sendError(
        context: 'Focus molecule result NOT {}',
        details: 'Result "$focusResult.toString()}"',
      );
      return false;
    }

    return true;
  }

  _defineWaitForElement() async {
    await _controller.runJavaScript('''
      async function waitForElement(selector) {
        return new Promise((resolve) => {
          const observer = new MutationObserver((mutations) => {
            for (const mutation of mutations) {
              if (mutation.type === 'childList') {
                const element = document.querySelector(selector);
                  
                if (element !== null) {
                  observer.disconnect();
                  resolve(element);
                }
              }
            }
          });
        
          observer.observe(document.body, {
            childList: true
          });
        });
      }
    ''');
  }

  Future<bool> _checkUnsupportedBrowser() async {
    String message = 'Apologies, we no longer support your browser...';

    String innerText = await _controller.runJavaScriptReturningResult('''
      document.body.innerText
    ''') as String;

    return innerText.contains(message);
  }

  _fixBrightnessMode() {
    if (!_firstBuild) {
      return;
    }

    _firstBuild = false;

    Brightness platformBrightness = MediaQuery.of(context).platformBrightness;
    _lightMode = platformBrightness == Brightness.light;
  }
}
