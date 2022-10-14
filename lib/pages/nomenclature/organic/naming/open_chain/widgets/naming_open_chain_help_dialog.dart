import 'package:flutter/material.dart';
import 'package:quimify_client/pages/nomenclature/organic/naming/open_chain/widgets/buttons/add_carbon_button.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';

class NamingOpenChainHelpDialog extends StatelessWidget {
  const NamingOpenChainHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuimifySlidesDialog(
      titleToContent: {
        'Botones': Wrap(
          runSpacing: 15,
          children: [
            Center(
              child: SizedBox(
                width: 100,
                child: AddCarbonButton(
                  enabled: true,
                  onPressed: () {},
                ),
              ),
            ),
            QuimifyDialogContentText(
              text: 'Sirve para enlazar un carbono al último de la cadena.',
            ),
          ],
        ),
      },
    );
  }
}
