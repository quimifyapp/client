import 'package:cliente/constants.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/text.dart';
import '../../../../../widgets/button.dart';

class FunctionButton extends StatelessWidget {
  const FunctionButton(
      {Key? key,
      required this.bonds,
      required this.text,
      required this.onPressed})
      : super(key: key);

  final int bonds;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 25, right: 25),
      child: Button(
        height: 60,
        onPressed: onPressed,
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          children: [
            SizedBox(width: 10),
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                bonds == 1
                    ? '-'
                    : bonds == 2
                        ? '='
                        : '≡',
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              formatOrganicFormula(text),
              style: const TextStyle(
                letterSpacing: 1,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Icon(Icons.add, color: quimifyTeal, size: 22,),
            const SizedBox(width: 5),
            const Text(
              'Enlazar',
              style: TextStyle(
                color: quimifyTeal,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
}
