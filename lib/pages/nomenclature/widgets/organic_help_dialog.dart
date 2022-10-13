import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_button.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class OrganicHelpDialog extends StatefulWidget {
  const OrganicHelpDialog({Key? key}) : super(key: key);

  @override
  State<OrganicHelpDialog> createState() => _OrganicHelpDialogState();
}

class _OrganicHelpDialogState extends State<OrganicHelpDialog> {
  late int _slide;

  @override
  void initState() {
    _slide = 0;
    super.initState();
  }

  void _firstButtonPressed() => setState(() => _slide = 1);

  void _secondButtonPressed() => setState(() => _slide = 2);

  void _thirdButtonPressed() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _slide,
      children: [
        QuimifyDialog(
          title: 'Orgánica',
          content: Wrap(
            runSpacing: 15,
            children: const [
              QuimifyDialogContentText(
                text: 'Los compuestos orgánicos son los que contienen carbonos '
                    'enlazados a hidrógenos.',
              ),
              QuimifyDialogContentText(
                text: 'Ejemplos de fórmula:',
                fontWeight: FontWeight.bold,
              ),
              Center(
                child: QuimifyDialogContentText(
                  text: 'CH₃ - CH₂ - COOH\n'
                      'CH₂ = CH - CH₂ - CONH₂',
                ),
              ),
              QuimifyDialogContentText(
                text: 'Ejemplos de nombre:',
                fontWeight: FontWeight.bold,
              ),
              Center(
                child: QuimifyDialogContentText(
                  text: 'ácido propanoico\n'
                      'but-3-enamida',
                ),
              ),
            ],
          ),
          actions: [
            QuimifyDialogButton(
              onPressed: _firstButtonPressed,
              text: 'Siguiente  ➔',
            ),
          ],
        ),
        QuimifyDialog(
          title: 'Formular',
          content: Wrap(
            runSpacing: 15,
            children: const [
              QuimifyDialogContentText(
                text: 'Formular consiste averiguar la fórmula dado el nombre.',
              ),
              QuimifyDialogContentText(
                text: 'Ejemplos:',
                fontWeight: FontWeight.bold,
              ),
              Center(
                child: QuimifyDialogContentText(
                  text: 'etanol   ➔   CH₃ - CH₂(OH)\n'
                      'propadieno   ➔   CH₂ = CH = CH₂',
                ),
              ),
            ],
          ),
          actions: [
            QuimifyDialogButton(
              onPressed: _secondButtonPressed,
              text: 'Siguiente  ➔',
            ),
          ],
        ),
        QuimifyDialog(
          title: 'Nombrar',
          content: Wrap(
            runSpacing: 15,
            children: const [
              QuimifyDialogContentText(
                text: 'Nombrar consiste averiguar el nombre dada la fórmula.',
              ),
              QuimifyDialogContentText(
                text: 'Ejemplos:',
                fontWeight: FontWeight.bold,
              ),
              Center(
                child: QuimifyDialogContentText(
                  text: 'CH₃ - CH₂(OH)   ➔   etanol\n'
                      'CH₂ = CH = CH₂   ➔   propadieno',
                ),
              ),
            ],
          ),
          actions: [
            QuimifyDialogButton(
              onPressed: _thirdButtonPressed,
              text: 'Entendido',
            ),
          ],
        ),
      ],
    );
  }
}
