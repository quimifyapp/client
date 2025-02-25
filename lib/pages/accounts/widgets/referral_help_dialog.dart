import 'package:flutter/material.dart';
import 'package:quimify_client/pages/accounts/widgets/video_examples_buttons.dart';
import 'package:quimify_client/pages/widgets/dialogs/help_slides_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';

class ReferralHelpDialog extends StatelessWidget {
  const ReferralHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HelpSlidesDialog(
      titleToContent: {
        '📲 Sube un vídeo': [
          Center(
            child: DialogContentText(
              richText: 'Sube un vídeo a *TikTok, Instagram o YouTube* que este relacionado o mencione a *Quimify*',
            ),
          ),
          DialogContentText(
            richText: '*Ejemplos:*',
          ),
          VideoExamplesButtons()
        ],
        '📈 Acumula visitas': [
          Center(
            child: DialogContentText(
              richText: 'Acumula visitas a través de varios vídeos y plataformas',
            ),
          ),
          DialogContentText(
            richText: '*Ejemplo:*',
          ),
          Center(
            child: DialogContentText(
              richText: 'TikTok vídeo 1 ➔ 50 mil visitas',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'TikTok vídeo 2 ➔ 200 mil visitas',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'Instagram vídeo 1 ➔ 120 mil visitas',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: 'YouTube vídeo 1 ➔ 30 mil visitas',
            ),
          ),
          Center(
            child: DialogContentText(
              richText: '*Total ➔ 400 mil visitas = 40€/\$*',
            ),
          ),
        ],
        '💸 Reclama tu dinero': [
          Center(
            child: DialogContentText(
              richText: 'Cuándo llegues a 100 mil visitas o más, escríbenos un email.\n\n Envía el link de todos los vídeos que quieres que tengamos en cuenta. Solo puedes enviar cada vídeo 1 vez así que piensa bien cuando hacerlo. \n\n Revisaremos todos los vídeos para comprobar sus visualizaciones en el momento de envío y ver que están relacionados o mencionan a Quimify. \n\n Si los vídeos pasan la revisión recibirás 10€/\$ por 100 mil visitas generadas. El pago se hará en tarjetas regalo de Amazon, Apple, Playstation, Starbucks, Netflix... etc, sujeto a disponibilidad.',
            ),
          ),
        ],
      },
    );
  }
}
