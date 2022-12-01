import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';

class HydrogenateButton extends StatelessWidget {
  const HydrogenateButton({
    Key? key,
    required this.width,
    required this.enabled,
    required this.onPressed,
  }) : super(key: key);

  final double width;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return QuimifyButton(
      height: 40,
      width: width,
      enabled: enabled,
      onPressed: onPressed,
      backgroundColor: const Color.fromARGB(255, 56, 133, 224),
      child: Image.asset(
        'assets/images/icons/hydrogenate.png',
        color: Theme.of(context).colorScheme.onPrimary,
        width: 28,
      ),
    );
  }
}
