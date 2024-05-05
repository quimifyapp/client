import 'package:flutter/material.dart';
import 'package:quimify_client/internet/api/results/classification.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/message_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_button.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_negative_button.dart';
import 'package:quimify_client/routes.dart';
import 'package:quimify_client/text.dart';

class ClassificationDialog extends StatelessWidget {
  const ClassificationDialog({
    Key? key,
    required this.classification,
    required this.formattedQuery,
    required this.richText,
    required this.onPressedDisagree,
  }) : super(key: key);

  final Classification classification;
  final String formattedQuery;
  final String richText;
  final VoidCallback onPressedDisagree;

  show(BuildContext context) async =>
      await showQuimifyDialog(context: context, dialog: this);

  _agreePressed(BuildContext context) {
    if (Routes.contains(classification)) {
      Navigator.pushNamed(
        context,
        Routes.fromClassification[classification]!,
        arguments: toDigits(formattedQuery),
      );
    } else {
      Navigator.of(context).pop();

      MessageDialog(
        title: '¡Estamos en ello!',
        details: classification == Classification.chemicalProblem
            ? 'Podremos resolver *problemas químicos* en próximas '
                'actualizaciones.'
            : classification == Classification.chemicalReaction
                ? 'Podremos resolver *reacciones químicas* en próximas '
                    'actualizaciones.'
                : 'Podremos resolver eso en próximas actualizaciones.',
      ).show(context);
    }
  }

  _disagreePressed(BuildContext context) {
    Navigator.of(context).pop();
    onPressedDisagree();
  }

  @override
  Widget build(BuildContext context) {
    return QuimifyDialog(
      title: 'Un momento...',
      content: [
        Center(
          child: DialogContentText(
            richText: richText,
          ),
        )
      ],
      actions: [
        DialogButton(
          text: 'Sí, eso es',
          onPressed: () => _agreePressed(context),
        ),
        const SizedBox(height: 8),
        DialogNegativeButton(
          text: 'No, seguir buscando',
          onPressed: () => _disagreePressed(context),
        ),
      ],
    );
  }
}
