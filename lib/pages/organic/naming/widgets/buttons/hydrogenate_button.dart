import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_gradient.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';

class HydrogenateButton extends StatelessWidget {
  const HydrogenateButton({
    Key? key,
    required this.enabled,
    required this.onPressed,
  }) : super(key: key);

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return QuimifyButton.gradient(
      height: 40,
      enabled: enabled,
      onPressed: onPressed,
      gradient: quimifyGradient,
      child: Image.asset(
        'assets/images/icons/hydrogenate.png',
        color: Theme.of(context).colorScheme.onPrimary,
        width: 28,
      ),
    );
  }
}
