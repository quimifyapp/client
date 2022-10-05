import 'package:cliente/pages/widgets/quimify_button.dart';
import 'package:flutter/material.dart';

class QuimifyIconButton extends StatelessWidget {
  const QuimifyIconButton({
    Key? key,
    this.width,
    required this.height,
    required this.backgroundColor,
    required this.onPressed,
    required this.icon,
    this.text,
  }) : super(key: key);

  const QuimifyIconButton.square({
    super.key,
    required this.height,
    required this.backgroundColor,
    required this.onPressed,
    required this.icon,
    this.text,
  }) : width = height;

  final double? width;
  final double height;
  final Color backgroundColor;
  final Widget icon;
  final Text? text;

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return QuimifyButton(
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Spacer(),
          icon,
          if (text != null) ...[
            const SizedBox(width: 8),
            text!,
          ],
          const Spacer(),
        ],
      ),
    );
  }
}
