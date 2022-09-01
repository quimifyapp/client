import 'package:flutter/material.dart';

import 'constants.dart';

class Button extends StatelessWidget {
  const Button({Key? key, required this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      // To avoid rounded corners overflow:
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        gradient: quimifyGradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox.expand(
        child: MaterialButton(
          onPressed: onPressed,
          child: const Text(
            'Calcular',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
