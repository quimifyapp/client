import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/internet/api/results/client_result.dart';
import 'package:quimify_client/internet/api/sign-in/sign_in_api.dart';
import 'package:quimify_client/pages/calculator/calculator_page.dart';
import 'package:quimify_client/pages/home/widgets/quimify_menu_button.dart';
import 'package:quimify_client/pages/inorganic/inorganic_page.dart';
import 'package:quimify_client/pages/organic/organic_page.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/message_dialog.dart';
import 'package:quimify_client/pages/widgets/gestures/quimify_swipe_detector.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';

import '../profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.clientResult,
    required this.user,
  }) : super(key: key);

  final ClientResult? clientResult;
  final QuimifyIdentity? user;

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
    if (widget.clientResult!.messagePresent) {
      if (widget.clientResult!.messageLinkPresent!) {
        MessageDialog.linked(
          title: widget.clientResult!.messageTitle!,
          details: widget.clientResult!.messageDetails!,
          linkLabel: widget.clientResult!.messageLinkName!,
          link: widget.clientResult!.messageLink!,
        ).show(context);
      } else {
        MessageDialog(
          title: widget.clientResult!.messageTitle!,
          details: widget.clientResult!.messageDetails!,
        ).show(context);
      }
    }
  }

  _showWelcomePopups() {
    if (widget.clientResult == null) {
      return;
    }

    if (widget.clientResult!.updateAvailable) {
      bool optionalUpdate = !widget.clientResult!.updateNeeded!;

      MessageDialog updateDialog = MessageDialog.linked(
        title: 'Actualización ${optionalUpdate ? 'disponible' : 'necesaria'}',
        details: widget.clientResult!.updateDetails,
        linkLabel: 'Actualizar',
        link: Platform.isAndroid
            ? 'https://quimify.com/android'
            : 'https://quimify.com/ios',
        closable: optionalUpdate,
      );

      updateDialog.show(context).then((_) => _showWelcomeMessagePopup());
    } else {
      _showWelcomeMessagePopup();
    }
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
    return PopScope(
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          return;
        }

        _returnButtonPressed();
      },
      child: QuimifyScaffold.noAd(
        header: SafeArea(
          bottom: false, // So it's not inside status bar
          child: Container(
            padding: const EdgeInsets.only(
              top: 15, // TODO 17.5?
              bottom: 20,
              left: 20,
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: IconButton(
                    icon: Image.asset(
                      'assets/images/icons/logo.png',
                      color: QuimifyColors.inverseText(context),
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
                  color: QuimifyColors.inverseText(context),
                ),
                //const SizedBox(width: 120),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 38,
                    alignment: Alignment.centerRight,
                    icon: widget.user?.photoUrl != null
                        ? CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.user?.photoUrl ?? ''),
                            radius: 19, // Adjust radius as needed
                          )
                        : Icon(
                            Icons.account_circle,
                            color: QuimifyColors.inverseText(context),
                          ),
                    onPressed: () {
                      if (widget.user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              user: widget.user, // Use non-null assertion here
                            ),
                          ),
                        );
                      }
                    },
                  ),
                )
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
                    color: QuimifyColors.foreground(context),
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
                  child: SingleChildScrollView(
                    child: _pages[_currentPage],
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
