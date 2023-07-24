import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:quimify_client/api/results/access_data_result.dart';
import 'package:quimify_client/pages/calculator/calculator_page.dart';
import 'package:quimify_client/pages/home/widgets/quimify_menu_button.dart';
import 'package:quimify_client/pages/home/widgets/quimify_home_bar.dart';
import 'package:quimify_client/pages/inorganic/inorganic_page.dart';
import 'package:quimify_client/pages/organic/organic_page.dart';
import 'package:quimify_client/pages/widgets/gestures/quimify_swipe_detector.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.clientResult,
  }) : super(key: key);

  final AccessDataResult? clientResult;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = const [
    InorganicPage(),
    OrganicPage(),
    CalculatorPage(),
  ];

  late int _currentPage;
  late final List<int> _visitedPagesStack;
  late final AutoSizeGroup autoSizeGroup;

  @override
  initState() {
    super.initState();

    _currentPage = 0;
    _visitedPagesStack = [];
    autoSizeGroup = AutoSizeGroup();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showWelcomePopups(),
    );
  }

  _showWelcomeMessagePopup() {
    if (widget.clientResult!.messagePresent) {
      if (widget.clientResult!.messageLinkPresent!) {
        QuimifyMessageDialog.linked(
          title: widget.clientResult!.messageTitle!,
          details: widget.clientResult!.messageDetails!,
          linkLabel: widget.clientResult!.messageLinkName!,
          link: widget.clientResult!.messageLink!,
        ).showIn(context);
      } else {
        QuimifyMessageDialog(
          title: widget.clientResult!.messageTitle!,
          details: widget.clientResult!.messageDetails!,
        ).showIn(context);
      }
    }
  }

  _showWelcomePopups() {
    if (widget.clientResult == null) {
      return;
    }

    if (!widget.clientResult!.updateAvailable) {
      _showWelcomeMessagePopup();
      return;
    }

    bool optionalUpdate = !widget.clientResult!.updateMandatory!;

    QuimifyMessageDialog updateDialog = QuimifyMessageDialog.linked(
      title: 'Actualización ${optionalUpdate ? 'disponible' : 'necesaria'}',
      details: widget.clientResult!.updateDetails,
      linkLabel: 'Actualizar',
      link: Platform.isAndroid
          ? 'https://play.google.com/store/apps/details?id=com.quimify'
          : 'https://apps.apple.com/es/app/quimify/id6443752619',
      closable: optionalUpdate,
    );

    updateDialog.showIn(context).then((value) => _showWelcomeMessagePopup());
  }

  _goToPage(int page) {
    if (_currentPage != page) {
      setState(() {
        _visitedPagesStack.remove(_currentPage);
        _visitedPagesStack.add(_currentPage);
        _currentPage = page;
      });
    }
  }

  bool _returnButtonPressed() {
    if (_visitedPagesStack.isEmpty) {
      if (_currentPage != 0) {
        setState(() {
          _currentPage = 0;
        });
        return false;
      }
      return true;
    } else {
      setState(() {
        _visitedPagesStack.remove(_currentPage);
        _currentPage = _visitedPagesStack.last;
        _visitedPagesStack.removeLast();
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _returnButtonPressed(),
      child: QuimifyScaffold(
        header: const QuimifyHomeBar(),
        body: QuimifySwipeDetector(
          leftSwipe: () => _goToPage((_currentPage - 1) % 3),
          rightSwipe: () => _goToPage((_currentPage + 1) % 3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    key: ValueKey(_currentPage),
                    children: [
                      QuimifyMenuButton(
                        title: 'Inorgánica',
                        selected: _currentPage == 0,
                        autoSizeGroup: autoSizeGroup,
                        onPressed: () => _goToPage(0),
                      ),
                      const SizedBox(width: 5),
                      QuimifyMenuButton(
                        title: 'Orgánica',
                        selected: _currentPage == 1,
                        autoSizeGroup: autoSizeGroup,
                        onPressed: () => _goToPage(1),
                      ),
                      const SizedBox(width: 5),
                      QuimifyMenuButton(
                        title: 'Calculadora',
                        selected: _currentPage == 2,
                        autoSizeGroup: autoSizeGroup,
                        onPressed: () => _goToPage(2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(
                      overscroll: false, // To avoid weird behavior
                    ),
                    child: SingleChildScrollView(
                      child: _pages[_currentPage],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
