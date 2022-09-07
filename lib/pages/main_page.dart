import 'dart:io';

import 'package:cliente/main.dart';
import 'package:cliente/widgets/dialog_popup.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import '../api/results/access_result.dart';
import '../constants.dart';
import 'calculator/calculator_page.dart';
import 'nomenclature/nomenclature_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.accessResult}) : super(key: key);

  final AccessResult? accessResult;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;

  static double widthFactor = 0.85;

  void _goToPage(int page) {
    if (currentPage != page) {
      setState(() {
        currentPage = page;
      });
    }
  }

  void _showWelcomeMessagePopup() {
    if (accessResult!.messagePresent) {
      if (accessResult!.messageLinkPresent!) {
        DialogPopup.linkedMessage(
          title: accessResult!.messageTitle!,
          details: accessResult!.messageDetails!,
          linkName: accessResult!.messageLinkName!,
          link: accessResult!.messageLink!,
        ).show(context);
      } else {
        DialogPopup.message(
          title: accessResult!.messageTitle!,
          details: accessResult!.messageDetails!,
        ).show(context);
      }
    }
  }

  void _showWelcomePopups() {
    if (accessResult != null) {
      if (accessResult!.updateAvailable) {
        DialogPopup.update(
          details: accessResult!.updateDetails,
          closable: !accessResult!.updateMandatory!,
          link: Platform.isAndroid
              ? 'https://play.google.com/store/apps/details?id=com.quimify'
              : 'https://apps.apple.com/pa/app/youtube/id544007664',
        ).show(context).then((value) => _showWelcomeMessagePopup());
      } else {
        _showWelcomeMessagePopup();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showWelcomePopups());
  }

  @override
  Widget build(BuildContext context) {
    SizedBox navigationBarItemSeparator = SizedBox(
      width: MediaQuery.of(context).size.width * 0.01 + 4,
    );

    Color enabledColor = Theme.of(context).colorScheme.onPrimary;
    Color disabledColor = Theme.of(context).colorScheme.outline;

    return WillPopScope(
      onWillPop: () async {
        if (currentPage == 0) {
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
          index: currentPage,
          children: [
            NomenclaturePage(),
            CalculatorPage(),
          ],
        ),
        // Navigation bar:
        extendBody: true, // So it's always floating on top
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: FractionallySizedBox(
            widthFactor: widthFactor,
            child: GestureDetector(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: quimifyGradient,
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.background,
                      width: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/icons/molecule.png',
                          width: 20,
                          color: currentPage == 0
                              ? enabledColor
                              : disabledColor,
                        ),
                        navigationBarItemSeparator,
                        Text(
                          'Formulación',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: currentPage == 0
                                ? enabledColor
                                : disabledColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      width: 0.5,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/icons/calculator.png',
                          width: 20,
                          color: currentPage == 1
                              ? enabledColor
                              : disabledColor,
                        ),
                        navigationBarItemSeparator,
                        Text(
                          'Calculadora',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: currentPage == 1
                                ? enabledColor
                                : disabledColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              onTapDown: (details) {
                double width = MediaQuery.of(context).size.width * widthFactor;
                _goToPage(details.localPosition.dx < width * 0.5 ? 0 : 1);
              },
            ),
          ),
        ),
      ),
    );
  }
}
