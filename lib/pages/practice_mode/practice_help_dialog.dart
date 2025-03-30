import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';

class PracticeHelpDialog extends StatelessWidget {
  const PracticeHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HelpSlidesDialog(
      titleToContent: {
        '🤓 Selecciona dificultad': [
          DialogContentText(
            richText: '*Dificultad:*',
          ),
          Center(
            child: DialogContentText(
              richText: 'Fácil',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'Intermedio',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'Difícil',
            ),
          ),
        ],
        '🤔 Selecciona categoría': [
          DialogContentText(
            richText: '*Categorías:*',
          ),
          Center(
            child: DialogContentText(
              richText: 'General',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'Balanceo de ecuaciones',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'Inorgánica',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'Orgánica',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'Química universitaria',
            ),
          ),
        ],
        '📊 Sube en el ranking': [
          Center(
            child: DialogContentText(
              richText: 'Juega y acumula puntos por cada respuesta correcta. \nSube puestos en el ranking para convertirte en el mejor!',
            ),
          ),
        ],
      },
    );
  }
}
