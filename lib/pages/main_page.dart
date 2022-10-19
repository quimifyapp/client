import 'dart:io';

import 'package:quimify_client/api/api.dart';
import 'package:quimify_client/api/results/access_result.dart';
import 'package:quimify_client/pages/calculator/calculator_page.dart';
import 'package:quimify_client/pages/nomenclature/nomenclature_page.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_gradient.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_message_dialog.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.accessResult}) : super(key: key);

  final AccessResult? accessResult;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const double _widthFactor = 0.85;

  int _currentPage = 0;

  void _goToPage(int page) {
    if (_currentPage != page) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  void _showWelcomeMessagePopup() {
    if (widget.accessResult!.messagePresent) {
      if (widget.accessResult!.messageLinkPresent!) {
        QuimifyMessageDialog.linked(
          title: widget.accessResult!.messageTitle!,
          details: widget.accessResult!.messageDetails!,
          linkName: widget.accessResult!.messageLinkName!,
          link: widget.accessResult!.messageLink!,
        ).show(context);
      } else {
        QuimifyMessageDialog(
          title: widget.accessResult!.messageTitle!,
          details: widget.accessResult!.messageDetails!,
        ).show(context);
      }
    }
  }

  void _showWelcomePopups() {
    if (widget.accessResult != null) {
      if (widget.accessResult!.updateAvailable) {
        bool optionalUpdate = !widget.accessResult!.updateMandatory!;

        QuimifyMessageDialog.linked(
          title: 'Actualización ${optionalUpdate ? 'disponible' : 'necesaria'}',
          details: widget.accessResult!.updateDetails,
          linkName: 'Actualizar',
          link: Platform.isAndroid
              ? 'https://play.google.com/store/apps/details?id=com.quimify'
              : 'https://apps.apple.com/pa/app/youtube/id544007664',
          closable: optionalUpdate,
        ).show(context).then((value) => _showWelcomeMessagePopup());
      } else {
        _showWelcomeMessagePopup();
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _showWelcomePopups());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizedBox navigationBarItemSeparator = SizedBox(
      width: MediaQuery.of(context).size.width * 0.01 + 4,
    );

    Color enabledColor = Theme.of(context).colorScheme.onPrimary;
    Color disabledColor = Theme.of(context).colorScheme.onPrimaryContainer;

    return WillPopScope(
      onWillPop: () async {
        if (_currentPage == 0) {
          Api().close();
          return true;
        } else {
          _goToPage(0);
          return false;
        }
      },
      child: Scaffold(
        // Body:
        body: IndexedStack(
          index: _currentPage,
          children: [
            NomenclaturePage(),
            CalculatorPage(),
          ],
        ),
        // Navigation bar:
        extendBody: true, // So it's always floating on top
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: FractionallySizedBox(
              widthFactor: _widthFactor,
              child: GestureDetector(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: quimifyGradient,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      width: 2,
                      strokeAlign: StrokeAlign.outside,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 27,
                            child: Container(),
                          ),
                          Image.asset(
                            'assets/images/icons/molecule.png',
                            width: 20,
                            color: _currentPage == 0
                                ? enabledColor
                                : disabledColor,
                          ),
                          navigationBarItemSeparator,
                          Text(
                            'Formulación',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: _currentPage == 0
                                  ? FontWeight.w800
                                  : FontWeight.bold,
                              color: _currentPage == 0
                                  ? enabledColor
                                  : disabledColor,
                            ),
                          ),
                          Flexible(
                            flex: 46,
                            child: Container(),
                          ),
                          Image.asset(
                            'assets/images/icons/calculator.png',
                            width: 20,
                            color: _currentPage == 1
                                ? enabledColor
                                : disabledColor,
                          ),
                          navigationBarItemSeparator,
                          Text(
                            'Calculadora',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: _currentPage == 1
                                  ? FontWeight.w800
                                  : FontWeight.bold,
                              color: _currentPage == 1
                                  ? enabledColor
                                  : disabledColor,
                            ),
                          ),
                          Flexible(
                            flex: 27,
                            child: Container(),
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 1.0,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ],
                  ),
                ),
                onTapUp: (details) {
                  double width =
                      MediaQuery.of(context).size.width * _widthFactor;
                  _goToPage(details.localPosition.dx < width * 0.5 ? 0 : 1);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
