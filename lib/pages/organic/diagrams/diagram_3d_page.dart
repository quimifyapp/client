import 'package:flutter/material.dart';
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
  late Color _from, _to;

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

  @override
  Widget build(BuildContext context) {
    // WebView's brightness mode is not real-time, so we set it at first build:

    if (_firstBuild) {
      _firstBuild = false;

      Brightness platformBrightness = MediaQuery.of(context).platformBrightness;

      _lightMode = platformBrightness == Brightness.light;
      _from = _lightMode ? Colors.white : Colors.black;
      _to = QuimifyColors.background(context);
    }

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
              colorFilter: ColorFilter.matrix(
                _lightMode
                    ? [
                        _to.red / _from.red, 0, 0, 0, 0,
                        0, _to.green / _from.green, 0, 0, 0,
                        0, 0, _to.blue / _from.blue, 0, 0,
                        0, 0, 0, 1, 0, // [from -> to]
                      ]
                    : [
                        1, 0, 0, 0, _to.red.toDouble(),
                        0, 1, 0, 0, _to.green.toDouble(),
                        0, 0, 1, 0, _to.blue.toDouble(),
                        0, 0, 0, 1, 0, // [from -> to] without dividing by 0
                      ],
              ),
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
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: resultToQuimifyMascot[_result]!,
                ),
              ],
            )
        ],
      ),
    );
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

    // TODO send error
  }

  _onPageFinished() async {
    if (!mounted) return; // For security reasons
    if (_result != null) return;

    if (await _checkUnsupportedBrowser()) {
      setState(() {
        _result = _Result.unsupportedBrowser;
      });
      // TODO send error
      return;
    }

    bool adaptedSuccessfully = await _adaptWebPage();

    if (adaptedSuccessfully) {
      await Future.delayed(const Duration(seconds: 1)); // Temporary fix

      setState(() {
        _result = _Result.successful;
      });
    } else {
      setState(() {
        _result = _Result.error;
      });
    }
  }

  Future<bool> _adaptWebPage() async {
    try {
      await _defineWaitForElement();

      try {
        await _runZoomOutMolecule();
      } catch (nonCriticalError) {
        // TODO send error
      }

      return await _runFocusOnMolecule();
    } catch (error) {
      // TODO send error
      return false;
    }
  }

  Future<bool> _checkUnsupportedBrowser() async {
    String message = 'Apologies, we no longer support your browser...';

    String innerText = await _controller.runJavaScriptReturningResult('''
      document.body.innerText
    ''') as String;

    return innerText.contains(message);
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
      // TODO send error
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
      // TODO send error
      return false;
    }

    return true;
  }
}
