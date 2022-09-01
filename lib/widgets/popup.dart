import 'package:flutter/material.dart';

import 'button.dart';
import 'constants.dart';

class Popup extends StatelessWidget {
  const Popup({Key? key, required this.title, required this.message})
      : super(key: key);

  final String title, message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actionsPadding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
      actions: [
        Row(
          children: [
            Button(
              width: 50,
              color: Colors.red.withOpacity(0.1),
              onPressed: () {},
              child: Image.asset(
                'assets/images/icons/report.png',
                color: Colors.red,
                width: 25,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Button.gradient(
                gradient: quimifyGradient,
                child: const Text(
                  'Entendido',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
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
