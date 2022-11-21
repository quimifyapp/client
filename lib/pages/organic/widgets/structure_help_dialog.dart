import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class StructureHelpDialog extends StatelessWidget {
  const StructureHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuimifySlidesDialog(
      titleToContent: {
        'Estructura': [
          const Center(
            child: QuimifyDialogContentText(
              text: 'Cada carbono es un vértice, y los hidrógenos se omiten.',
            ),
          ),
          const QuimifyDialogContentText(
            text: 'Ejemplo:',
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
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
        'Enlace simple': [
          const Center(
            child: QuimifyDialogContentText(
              text: 'Se representa con una línea.',
            ),
          ),
          const QuimifyDialogContentText(
            text: 'Ejemplo:',
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
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
        'Enlace doble': [
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
            padding: const EdgeInsets.only(top: 10),
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
        'Enlace triple': [
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
            padding: const EdgeInsets.only(top: 10),
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
      },
    );
  }
}
