import 'dart:io';
import 'package:quimify_client/api/results/access_result.dart';
import 'package:quimify_client/pages/calculator/calculator_page.dart';
import 'package:quimify_client/pages/home/widgets/bar_button.dart';
import 'package:quimify_client/pages/nomenclature/inorganic/inorganic_page.dart';
import 'package:quimify_client/pages/nomenclature/organic/organic_page.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_home_bar.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.accessResult,
  }) : super(key: key);

  final AccessResult? accessResult;

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

  @override
  void initState() {
    _currentPage = 0;
    _visitedPagesStack = [];

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showWelcomePopups(),
    );

    super.initState();
  }

  void _goToPage(int page) {
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                height: 60,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    BarButton(
                      title: 'Inorgánica',
                      selected: _currentPage == 0,
                      onPressed: () => _goToPage(0),
                    ),
                    const SizedBox(width: 5),
                    BarButton(
                      title: 'Orgánica',
                      selected: _currentPage == 1,
                      onPressed: () => _goToPage(1),
                    ),
                    const SizedBox(width: 5),
                    BarButton(
                      title: 'Calculadora',
                      selected: _currentPage == 2,
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
    );
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
              : 'https://apps.apple.com/es/app/quimify/id6443752619',
          closable: optionalUpdate,
        ).show(context).then((value) => _showWelcomeMessagePopup());
      } else {
        _showWelcomeMessagePopup();
      }
    }
  }
}
