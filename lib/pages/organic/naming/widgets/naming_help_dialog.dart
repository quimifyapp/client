import 'package:flutter/material.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/add_carbon_button.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/hydrogenate_button.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/undo_button.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/objects/history_button.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class NamingHelpDialog extends StatelessWidget {
  const NamingHelpDialog({
    Key? key,
    required this.buttonHeight,
  }) : super(key: key);

  final double buttonHeight;

  @override
  Widget build(BuildContext context) {
    BoxDecoration exampleButtonBorder = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        width: 1,
        color: QuimifyColors.secondary(context),
        strokeAlign: BorderSide.strokeAlignOutside, // So size doesn't change
      ),
    );

    return HelpSlidesDialog(
      titleToContent: {
        'Sustituyentes': [
          Container(
            decoration: exampleButtonBorder,
            height: 60,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: QuimifyColors.background(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    'assets/images/icons/single-bond.png',
                    color: QuimifyColors.primary(context),
                    width: 30,
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  'H',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Hidrógeno',
                  style: TextStyle(
                    color: QuimifyColors.teal(),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.add,
                  color: QuimifyColors.teal(),
                  size: 22,
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
          const Center(
            child: DialogContentText(
              richText: 'En la lista aparecen los sustituyentes que se pueden '
                  'enlazar al carbono.',
            ),
          ),
          const DialogContentText(
            richText: '*Ejemplo:*',
          ),
          Center(
            child: Text(
              'CH₃ –',
              style: TextStyle(
                color: QuimifyColors.primary(context),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Center(
            child: DialogContentText(
              richText: '(carbono con 3 hidrógenos)',
            ),
          ),
        ],
        'Radicales': [
          const Center(
            child: DialogContentText(
              richText: 'Son ramificaciones de la cadena principal de carbonos.',
            ),
          ),
          const DialogContentText(
            richText: '*Ejemplo:*',
          ),
          Center(
            child: Image.asset(
              'assets/images/icons/2-methylpropane.png',
              height: 90,
              color: QuimifyColors.primary(context),
            ),
          ),
          const Center(
            child: DialogContentText(
              richText: '(2-metilpropano)',
            ),
          ),
        ],
        'Enlazar carbono': [
          Center(
            child: SizedBox(
              width: 100,
              child: AddCarbonButton(
                height: buttonHeight,
                enabled: true,
                onPressed: () {},
              ),
            ),
          ),
          const Center(
            child: DialogContentText(
              richText: 'Este botón sirve para añadir un carbono a la cadena.',
            ),
          ),
        ],
        'Hidrogenar': [
          Center(
            child: SizedBox(
              width: 100,
              child: HydrogenateButton(
                height: buttonHeight,
                enabled: true,
                onPressed: () {},
              ),
            ),
          ),
          const Center(
            child: DialogContentText(
              richText: 'Este botón sirve para enlazar varios hidrógenos al '
                  'carbono.',
            ),
          ),
        ],
        'Historial': [
          Center(
            child: Container(
              width: 100,
              decoration: exampleButtonBorder,
              child: HistoryButton(
                height: buttonHeight,
                onPressed: () {},
              ),
            ),
          ),
          const Center(
            child: DialogContentText(
              richText: 'Este botón sirve para ver tus resultados anteriores.',
            ),
          ),
        ],
        'Deshacer': [
          Center(
            child: SizedBox(
              width: 100,
              child: UndoButton(
                height: buttonHeight,
                enabled: true,
                onPressed: () {},
              ),
            ),
          ),
          const Center(
            child: DialogContentText(
              richText: 'Este botón sirve para deshacer el último cambio.',
            ),
          ),
        ],
      },
    );
  }
}
