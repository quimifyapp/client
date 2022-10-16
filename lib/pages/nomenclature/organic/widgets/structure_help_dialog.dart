import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class StructureHelpDialog extends StatelessWidget {
  const StructureHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuimifySlidesDialog(
      titleToContent: {
        'Estructura': Wrap(
          runSpacing: 15,
          children: [
            const Center(
              child: QuimifyDialogContentText(
                text: 'Cada vértice se corresponde con un carbono. Los '
                    'hidrógenos se omiten.',
              ),
            ),
            const QuimifyDialogContentText(
              text: 'Ejemplo:',
              fontWeight: FontWeight.bold,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Image.asset(
                  'assets/images/icons/butane-diagram.png',
                  height: 130,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const Center(
              child: QuimifyDialogContentText(
                text: '(butano)',
              ),
            ),
          ],
        ),
        'Enlace simple': Wrap(
          runSpacing: 15,
          children: [
            const Center(
              child: QuimifyDialogContentText(
                text: 'Se representa con una sola línea.',
              ),
            ),
            const QuimifyDialogContentText(
              text: 'Ejemplo:',
              fontWeight: FontWeight.bold,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Image.asset(
                  'assets/images/icons/butane.png',
                  height: 50,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const Center(
              child: QuimifyDialogContentText(
                text: '(butano)',
              ),
            ),
          ],
        ),
        'Enlace doble' : Wrap(
          runSpacing: 15,
          children: [
            const Center(
              child: QuimifyDialogContentText(
                text: 'Se representa con dos líneas.',
              ),
            ),
            const QuimifyDialogContentText(
              text: 'Ejemplo:',
              fontWeight: FontWeight.bold,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Image.asset(
                  'assets/images/icons/but-2-ene.png',
                  height: 50,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const Center(
              child: QuimifyDialogContentText(
                text: '(but-2-eno)',
              ),
            ),
          ],
        ),
        'Enlace triple' : Wrap(
          runSpacing: 15,
          children: [
            const Center(
              child: QuimifyDialogContentText(
                text: 'Se representa con tres líneas.',
              ),
            ),
            const QuimifyDialogContentText(
              text: 'Ejemplo:',
              fontWeight: FontWeight.bold,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Image.asset(
                  'assets/images/icons/but-2-yne.png',
                  height: 50,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const Center(
              child: QuimifyDialogContentText(
                text: '(but-2-ino)',
              ),
            ),
          ],
        ),
      },
    );
  }
}
