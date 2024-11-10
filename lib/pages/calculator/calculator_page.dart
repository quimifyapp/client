import 'dart:async';

import 'package:flutter/material.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:quimify_client/pages/calculator/equation/equation_page.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/molecular_mass_page.dart';
import 'package:quimify_client/pages/calculator/widgets/equation_help_dialog.dart';
import 'package:quimify_client/pages/calculator/widgets/molecular_mass_help_dialog.dart';
import 'package:quimify_client/pages/home/widgets/quimify_card.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:quimify_client/subsription_service.dart';
import 'package:quimify_client/text.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _subscriptionService = getIt<SubscriptionService>();
  bool _isSubscribed = false;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _isSubscribed = _subscriptionService.isSubscribed;
    _subscription =
        _subscriptionService.subscriptionStream.listen((isSubscribed) {
      if (mounted) {
        setState(() {
          _isSubscribed = isSubscribed;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const QuimifySectionTitle(
          title: 'Masa molecular',
          helpDialog: MolecularMassHelpDialog(),
        ),
        const SizedBox(height: 15),
        const QuimifyCard(
          body: {
            'Fe₂O₃': '159.68 g/mol',
            'C₅H₆O₂': '110.10 g/mol',
            'NaCl': '58.35 g/mol',
            'H₂S': '34.08 g/mol',
            'CH₃CN': '41.05 g/mol',
            'SiH₄': '32.12 g/mol',
          },
          page: MolecularMassPage(),
        ),
        const QuimifySectionTitle(
          title: 'Balancear reacción',
          helpDialog: EquationHelpDialog(),
        ),
        const SizedBox(height: 15),
        QuimifyCard(
          // TODO check for overflow
          body: {
            toEquation('H₂ + O₂', 'H₂O'): toEquation('2H₂ + O₂', '2H₂O'),
            toEquation('NH₃', 'N₂ + H₂'): toEquation('2NH₃', 'N₂ + 3H₂'),
            toEquation('Fe + O₂', 'Fe₂O₃'): toEquation('4Fe + 3O₂', '2Fe₂O₃'),
          },
          page: const EquationPage(),
          // If user is subscribed then it will allow navigating
          allowNavigating: _isSubscribed,
          onPressed: _isSubscribed
              ? null
              : () {
                  RevenueCatUI.presentPaywallIfNeeded('Premium');
                },
        ),
      ],
    );
  }
}
