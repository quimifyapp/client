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
  const HomePage({Key? key, required this.accessResult}) : super(key: key);

  final AccessResult? accessResult;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void _enterPage(int page) {
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
      onWillPop: () async {
        return _returnButtonPressed();
      },
      child: Scaffold(
        body: QuimifyScaffold(
          header: const QuimifyHomeBar(),
          body: Column(
            children: [
              Container(
                height: 65,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    BarButton(
                      title: 'Inorgánica',
                      selected: _currentPage == 0,
                      onPressed: () => _enterPage(0),
                    ),
                    const SizedBox(width: 5),
                    BarButton(
                      title: 'Orgánica',
                      selected: _currentPage == 1,
                      onPressed: () => _enterPage(1),
                    ),
                    const SizedBox(width: 5),
                    BarButton(
                      title: 'Calculadora',
                      selected: _currentPage == 2,
                      onPressed: () => _enterPage(2),
                    ),
                  ],
                ),
              ),
              IndexedStack(
                index: _currentPage,
                children: [
                  InorganicPage(),
                  OrganicPage(),
                  CalculatorPage(),
                ],
              ),
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
