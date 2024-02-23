import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class TipShapeHelpDialog extends StatelessWidget {
  const TipShapeHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelpSlidesDialog(
      titleToContent: {
        'Terminación': [
          const Center(
            child: DialogContentText(
              richText: 'Es la forma de la punta del radical.',
            ),
          ),
          const DialogContentText(
            richText: '*Terminación normal:*',
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Image.asset(
                'assets/images/icons/propyl.png',
                height: 19,
                color: QuimifyColors.primary(context),
              ),
            ),
          ),
          const Center(
            child: DialogContentText(
              richText: '(radical propil)',
            ),
          ),
        ],
      },
    );
  }
}
