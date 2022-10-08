import 'package:auto_size_text/auto_size_text.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/molecular_mass_page.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_home_bar.dart';
import 'package:quimify_client/pages/widgets/menus/quimify_card.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatelessWidget {
  CalculatorPage({Key? key}) : super(key: key);

  final AutoSizeGroup autoSizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold(
      header: const QuimifyHomeBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            const QuimifySectionTitle(title: 'Calculadora'),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  QuimifyCard.custom(
                    title: 'Masa molecular',
                    customBody: Container(
                      alignment: Alignment.center,
                      color: Theme.of(context).colorScheme.surface,
                      padding: const EdgeInsets.all(17),
                      child: Image.asset(
                        'assets/images/icons/scale.png',
                        height: 61,
                        color: quimifyTeal,
                      ),
                    ),
                    page: const MolecularMassPage(),
                  ),
                  const SizedBox(height: 20),
                  const QuimifyCard.locked(
                    title: 'Ajustar reacción',
                  ),
                  // To keep it above navigation bar:
                  const SizedBox(height: 2 * 30 + 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
