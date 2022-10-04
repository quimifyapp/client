import 'package:cliente/pages/widgets/quimify_button.dart';
import 'package:flutter/material.dart';

class QuimifyIconButton extends StatelessWidget {
  const QuimifyIconButton({
    Key? key,
    this.height,
    required this.color,
    required this.backgroundColor,
    this.text,
    required this.icon,
  }) : super(key: key);

  final double? height;
  final Color color, backgroundColor;
  final Widget icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return QuimifyButton(
      height: height,
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
                fontSize: 15,
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
