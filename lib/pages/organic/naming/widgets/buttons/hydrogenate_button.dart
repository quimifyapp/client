import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class HydrogenateButton extends StatelessWidget {
  const HydrogenateButton({
    Key? key,
    required this.height,
    required this.enabled,
    required this.onPressed,
  }) : super(key: key);

  final double height;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return QuimifyButton.gradient(
      height: height,
      enabled: enabled,
      onPressed: onPressed,
      child: Image.asset(
        'assets/images/icons/hydrogenate.png',
        color: QuimifyColors.inverseText(context),
        width: 28,
      ),
    );
  }
}
