import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class StructureHelpDialog extends StatelessWidget {
  const StructureHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        'Estructura': [
          const Center(
            child: DialogContentText(
              text: 'Cada carbono es un vértice. Los hidrógenos se omiten.',
            ),
          ),
          const DialogContentText(
            text: 'Ejemplo:',
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Image.asset(
                'assets/images/icons/butane-diagram.png',
                height: 130,
                color: QuimifyColors.primary(context),
              ),
            ),
          ),
          const Center(
            child: DialogContentText(
              text: '(butano)',
            ),
          ),
        ],
        'Enlace simple': [
          const Center(
            child: DialogContentText(
              text: 'Se representa con 1 línea.',
            ),
          ),
          const DialogContentText(
            text: 'Ejemplo:',
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Image.asset(
                'assets/images/icons/butane.png',
                height: 50,
                color: QuimifyColors.primary(context),
              ),
            ),
          ),
          const Center(
            child: DialogContentText(
              text: '(butano)',
            ),
          ),
        ],
        'Enlace doble': [
          const Center(
            child: DialogContentText(
              text: 'Se representa con 2 líneas.',
            ),
          ),
          const DialogContentText(
            text: 'Ejemplo:',
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Image.asset(
                'assets/images/icons/but-2-ene.png',
                height: 50,
                color: QuimifyColors.primary(context),
              ),
            ),
          ),
          const Center(
            child: DialogContentText(
              text: '(but-2-eno)',
            ),
          ),
        ],
        'Enlace triple': [
          const Center(
            child: DialogContentText(
              text: 'Se representa con 3 líneas.',
            ),
          ),
          const DialogContentText(
            text: 'Ejemplo:',
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Image.asset(
                'assets/images/icons/but-2-yne.png',
                height: 50,
                color: QuimifyColors.primary(context),
              ),
            ),
          ),
          const Center(
            child: DialogContentText(
              text: '(but-2-ino)',
            ),
          ),
        ],
      },
    );
  }
}
