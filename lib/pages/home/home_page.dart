import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/api/results/access_data_result.dart';
import 'package:quimify_client/pages/calculator/calculator_page.dart';
import 'package:quimify_client/pages/home/widgets/quimify_menu_button.dart';
import 'package:quimify_client/pages/inorganic/inorganic_page.dart';
import 'package:quimify_client/pages/organic/organic_page.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_message_dialog.dart';
import 'package:quimify_client/pages/widgets/gestures/quimify_swipe_detector.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/utils/quimify_responsive_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.accessDataResult,
  }) : super(key: key);

  final AccessDataResult? accessDataResult;

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
  late final AutoSizeGroup _autoSizeGroup;

  @override
  initState() {
    super.initState();

    _currentPage = 0;
    _visitedPagesStack = [];
    _autoSizeGroup = AutoSizeGroup();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showWelcomePopups(),
    );
  }

  _showWelcomeMessagePopup() {
    if (widget.accessDataResult!.messagePresent) {
      if (widget.accessDataResult!.messageLinkPresent!) {
        QuimifyMessageDialog.linked(
          title: widget.accessDataResult!.messageTitle!,
          details: widget.accessDataResult!.messageDetails!,
          linkLabel: widget.accessDataResult!.messageLinkName!,
          link: widget.accessDataResult!.messageLink!,
        ).show(context);
      } else {
        QuimifyMessageDialog(
          title: widget.accessDataResult!.messageTitle!,
          details: widget.accessDataResult!.messageDetails!,
        ).show(context);
      }
    }
  }

  _showWelcomePopups() {
    if (widget.accessDataResult == null) {
      return;
    }

    if (!widget.accessDataResult!.updateAvailable) {
      _showWelcomeMessagePopup();
      return;
    }

    bool optionalUpdate = !widget.accessDataResult!.updateMandatory!;

    QuimifyMessageDialog updateDialog = QuimifyMessageDialog.linked(
      title: 'Actualización ${optionalUpdate ? 'disponible' : 'necesaria'}',
      details: widget.accessDataResult!.updateDetails,
      linkLabel: 'Actualizar',
      link: Platform.isAndroid
          ? 'https://play.google.com/store/apps/details?id=com.quimify'
          : 'https://apps.apple.com/es/app/quimify/id6443752619',
      closable: optionalUpdate,
    );

    updateDialog.show(context).then((value) => _showWelcomeMessagePopup());
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
        showBannerAd: false,
        header: SafeArea(
          bottom: false, // So it's not inside status bar
          child: Container(
            /// Example of use of a [ResponsiveValue] extension
            padding: context.whenSmallDevice<EdgeInsetsGeometry>(
              defaultValue: const EdgeInsets.only(
                top: 15, // TODO 17.5?
                bottom: 20,
                left: 20,
              ),
              extraSmallValue: const EdgeInsets.only(left: 20),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: IconButton(
                    icon: Image.asset(
                      'assets/images/icons/logo.png',
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    // To remove native effects:
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    // So it fills container (48 x 48):
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 15),
                Image.asset(
                  'assets/images/icons/branding-slim.png',
                  height: 17,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
          ),
        ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 6),
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
                        autoSizeGroup: _autoSizeGroup,
                        onPressed: () => _goToPage(0),
                      ),
                      const SizedBox(width: 5),
                      QuimifyMenuButton(
                        title: 'Orgánica',
                        selected: _currentPage == 1,
                        autoSizeGroup: _autoSizeGroup,
                        onPressed: () => _goToPage(1),
                      ),
                      const SizedBox(width: 5),
                      QuimifyMenuButton(
                        title: 'Calculadora',
                        selected: _currentPage == 2,
                        autoSizeGroup: _autoSizeGroup,
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
                const SizedBox(height: 5), // + 15 from cards = 20
              ],
            ),
          ),
        ),
      ),
    );
  }
}
