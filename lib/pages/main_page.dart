import 'dart:io';

import 'package:cliente/api/api.dart';
import 'package:cliente/api/results/access_result.dart';
import 'package:cliente/constants.dart';
import 'package:cliente/pages/calculator/calculator_page.dart';
import 'package:cliente/pages/nomenclature/nomenclature_page.dart';
import 'package:cliente/widgets/dialog_popup.dart';
import 'package:flutter/material.dart';

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
    if (widget.accessResult!.messagePresent) {
      if (widget.accessResult!.messageLinkPresent!) {
        DialogPopup.linkedMessage(
          title: widget.accessResult!.messageTitle!,
          details: widget.accessResult!.messageDetails!,
          linkName: widget.accessResult!.messageLinkName!,
          link: widget.accessResult!.messageLink!,
        ).show(context);
      } else {
        DialogPopup.message(
          title: widget.accessResult!.messageTitle!,
          details: widget.accessResult!.messageDetails!,
        ).show(context);
      }
    }
  }

  void _showWelcomePopups() {
    if (widget.accessResult != null) {
      if (widget.accessResult!.updateAvailable) {
        DialogPopup.update(
          details: widget.accessResult!.updateDetails,
          closable: !widget.accessResult!.updateMandatory!,
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

    Color enabledColor = Colors.white;
    Color disabledColor = Colors.white70;

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
          padding: const EdgeInsets.only(bottom: 30),
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
                      color: const Color.fromARGB(255, 247, 247, 247),
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
