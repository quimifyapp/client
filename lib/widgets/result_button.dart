import 'package:flutter/material.dart';

import 'button.dart';

class ResultButton extends StatelessWidget {
  const ResultButton(
      {Key? key,
        required this.icon,
        required this.size,
        this.text,
        required this.color,
        required this.backgroundColor})
      : super(key: key);

  final double size;
  final Widget icon;
  final String? text;
  final Color color, backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Button(
      width: size,
      height: size,
      color: backgroundColor,
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Spacer(),
          icon,
          if (text != null) ...[
            const SizedBox(width: 8),
            Text(
              text!,
              style: TextStyle(
                color: color,
                fontSize: 16,
                //fontWeight: FontWeight.bold
              ),
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}