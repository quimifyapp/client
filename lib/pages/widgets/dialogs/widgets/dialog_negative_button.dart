import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class DialogNegativeButton extends StatelessWidget {
  const DialogNegativeButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 10;
    const double borderWidth = 2;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: QuimifyColors.gradient(),
      ),
      child: Container(
        margin: EdgeInsets.all(borderWidth),
        clipBehavior: Clip.hardEdge, // To prevent corners overflow
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius - borderWidth),
          color: QuimifyColors.foreground(context),
        ),
        child: SizedBox.expand(
          child: MaterialButton(
            padding: const EdgeInsets.all(0),
            splashColor: Colors.transparent,
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(
                color: QuimifyColors.teal(),
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
