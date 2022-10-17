import 'package:flutter/material.dart';
import 'package:quimify_client/pages/nomenclature/organic/naming/open_chain/widgets/buttons/add_carbon_button.dart';
import 'package:quimify_client/pages/nomenclature/organic/naming/open_chain/widgets/buttons/hydrogenate_button.dart';
import 'package:quimify_client/pages/nomenclature/organic/naming/open_chain/widgets/buttons/undo_button.dart';
import 'package:quimify_client/pages/nomenclature/organic/naming/open_chain/widgets/buttons/functional_group_button.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class NamingOpenChainHelpDialog extends StatelessWidget {
  const NamingOpenChainHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration functionalButtonBorder = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Theme.of(context).colorScheme.tertiary,
        width: 1,
      ),
    );

    return QuimifySlidesDialog(
      titleToContent: {
        'Sustituyentes': [
          Container(
            decoration: functionalButtonBorder,
            child: FunctionalGroupButton(
              bonds: 1,
              text: 'H',
              actionText: 'Hidrógeno',
              onPressed: () {},
            ),
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: 'En la lista aparecen los sustituyentes que se pueden '
                  'enlazar al carbono.',
            ),
          ),
          const QuimifyDialogContentText(
            text: 'Ejemplo:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: Text(
              'CH₃ —',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: '(carbono con tres hidrógenos)',
            ),
          ),
        ],
        'Radicales': [
          Container(
            decoration: functionalButtonBorder,
            child: FunctionalGroupButton(
              bonds: 1,
              text: 'CH2 — CH3',
              actionText: 'Radical',
              onPressed: () {},
            ),
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: 'Son ramificaciones de la cadena principal de carbonos.',
            ),
          ),
          const QuimifyDialogContentText(
            text: 'Ejemplo:',
            fontWeight: FontWeight.bold,
          ),
          Center(
            child: Image.asset(
              'assets/images/icons/2-methylpropane.png',
              height: 90,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: '(2-metilpropano)',
            ),
          ),
        ],
        'Enlazar carbono': [
          Center(
            child: SizedBox(
              width: 100,
              child: AddCarbonButton(
                enabled: true,
                onPressed: () {},
              ),
            ),
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: 'Este botón sirve para añadir un carbono a la cadena.',
            ),
          ),
        ],
        'Hidrogenar': [
          Center(
            child: SizedBox(
              width: 100,
              child: HydrogenateButton(
                enabled: true,
                onPressed: () {},
              ),
            ),
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: 'Este botón sirve para enlazar hidrógenos al carbono, '
                  'hasta que solo quede un enlace libre.',
            ),
          ),
        ],
        'Deshacer': [
          Center(
            child: SizedBox(
              width: 100,
              child: UndoButton(
                enabled: true,
                onPressed: () {},
              ),
            ),
          ),
          const Center(
            child: QuimifyDialogContentText(
              text: 'Este botón sirve para deshacer el último cambio.',
            ),
          ),
        ],
      },
    );
  }
}
