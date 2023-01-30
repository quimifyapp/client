import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_button.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';
import 'package:url_launcher/url_launcher.dart';

class QuimifyThanksDialog extends StatelessWidget {
  const QuimifyThanksDialog({
    Key? key,
    required this.reportLabel,
    required this.reportDetails,
  }) : super(key: key);

  final String reportLabel;
  final String? reportDetails;

  static const double _iconHeight = 30;
  static const String _discordUrl = 'https://discord.gg/VNUqxfSn';
  static const String _emailAddress = 'soporte@quimify.com';

  Future<void> showIn(BuildContext context) async =>
      await showQuimifyDialog(context: context, closable: true, dialog: this);

  void _exit(BuildContext context) => Navigator.of(context).pop();

  void _launchUrl(Uri url, BuildContext context) async {
    if (await canLaunchUrl(url)) {
      launchUrl(url, mode: LaunchMode.externalApplication);
      _exit(context);
    }
  }

  void _discordPressed(BuildContext context) async =>
      _launchUrl(Uri.parse(_discordUrl), context);

  void _emailPressed(BuildContext context) async {
    final mailtoLink = Mailto(
      to: [_emailAddress],
      subject: 'Necesito ayuda',
      body: '$reportLabel\n'
          '${reportDetails != null ? '$reportDetails\n\n' : '\n'}',
    );

    _launchUrl(Uri.parse(mailtoLink.toString()), context);
  }

  @override
  Widget build(BuildContext context) {
    return QuimifyDialog(
      title: 'Muchas gracias',
      content: [
        Column(
          children: [
            const Center(
              child: QuimifyDialogContentText(
                text: 'Si necesitas ayuda, escríbenos y te contestaremos '
                    'rápidamente.',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () => _discordPressed(context),
                  child: Image.asset(
                    'assets/images/discord.png',
                    height: _iconHeight,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _emailPressed(context),
                  child: Image.asset(
                    'assets/images/gmail.png',
                    height: _iconHeight - 1, // Optical illusion
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 5),
          ],
        )
      ],
      actions: [
        QuimifyDialogButton(
          onPressed: () => _exit(context),
          text: 'Entendido',
        ),
      ],
    );
  }
}
