import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_message_dialog.dart';

class CalculatorHelpDialog extends StatelessWidget {
  const CalculatorHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const QuimifyMessageDialog(
      title: 'Calculadora',
      details: 'En este apartado podrás resolver diversos cálculos químicos.',
    );
  }
}
