import 'package:flutter/material.dart';

class QuimifyHomeBar extends StatelessWidget {
  const QuimifyHomeBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false, // So it's not inside status bar
      child: Container(
        padding: const EdgeInsets.only(
          top: 10,
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
                  color: Theme.of(context).colorScheme.onPrimary,
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
              'assets/images/icons/branding-slim.png',
              height: 17,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
