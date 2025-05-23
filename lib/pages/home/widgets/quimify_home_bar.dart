import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class QuimifyHomeBar extends StatelessWidget {
  const QuimifyHomeBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentLanguage = Localizations.localeOf(context).languageCode;
    return SafeArea(
      bottom: false, // So it's not inside status bar
      child: Container(
        padding: const EdgeInsets.only(
          top: 15, // TODO 17.5?
          bottom: 20,
          left: 20,
        ),
        child: Row(
          children: [
            SizedBox(
              height: 48,
              width: 48,
              child: IconButton(
                icon: Image.asset(
                  'assets/images/icons/logo.png',
                  color: QuimifyColors.inverseText(context),
                ),
                // To remove native effects:
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                // So it fills container (48 x 48):
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 15),
            Image.asset(
              currentLanguage == 'es'
                  ? 'assets/images/icons/branding-slim.png'
                  : 'assets/images/icons/branding-slim-english.png',
              height: 17,
              color: QuimifyColors.inverseText(context),
            ),
          ],
        ),
      ),
    );
  }
}
