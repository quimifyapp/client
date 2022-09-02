import 'package:flutter/material.dart';

import 'button.dart';
import 'constants.dart';

class DialogPopup extends StatelessWidget {
  const DialogPopup({Key? key, required this.title, this.details})
      : super(key: key);

  final String title;
  final String? details;

  @override
  Widget build(BuildContext context) {
    Text? content;
    if (details != null) {
      if (details!.isNotEmpty) {
        content = Text(
          details!,
          textAlign: TextAlign.center,
        );
      }
    }

    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22),
      ),
      content: content,
      contentPadding:
          const EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actionsPadding: const EdgeInsets.only(
        bottom: 20,
        left: 15,
        right: 15,
      ),
      actions: [
        Row(
          children: [
            Button(
              width: 50,
              color: const Color.fromARGB(255, 255, 241, 241),
              onPressed: () {},
              child: Image.asset(
                'assets/images/icons/report.png',
                color: const Color.fromARGB(255, 255, 96, 96),
                width: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Button.gradient(
                gradient: quimifyGradient,
                child: const Text(
                  'Entendido',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        )
      ],
    );
  }
}
