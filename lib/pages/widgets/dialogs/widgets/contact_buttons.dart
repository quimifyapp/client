import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:quimify_client/utils/localisation_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactButtons extends StatelessWidget {
  const ContactButtons({
    Key? key,
    this.emailBody,
    this.afterClicked,
  }) : super(key: key);

  final String? emailBody;
  final VoidCallback? afterClicked;

  static const double _iconHeight = 35;
  static const String _discordUrl = 'https://quimify.com/discord';
  static const String _emailAddress = 'soporte@quimify.com';

  _launchUrl(Uri url, BuildContext context) async {
    if (await canLaunchUrl(url)) {
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  _pressedDiscordButton(BuildContext context) {
    _launchUrl(Uri.parse(_discordUrl), context);

    if (afterClicked != null) {
      afterClicked!();
    }
  }

  _pressedEmailButton(BuildContext context) {
    final mailtoLink = Mailto(
      to: [_emailAddress],
      subject: context.l10n.iNeedHelp,
      body: emailBody,
    );

    _launchUrl(Uri.parse(mailtoLink.toString()), context);

    if (afterClicked != null) {
      afterClicked!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Spacer(),
          GestureDetector(
            onTap: () => _pressedDiscordButton(context),
            child: Image.asset(
              'assets/images/discord.png',
              height: _iconHeight,
            ),
          ),
          const SizedBox(width: 12.5),
          GestureDetector(
            onTap: () => _pressedEmailButton(context),
            child: Image.asset(
              'assets/images/gmail.png',
              height: _iconHeight - 1, // Optical illusion
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
