import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';

class AddCarbonButton extends StatelessWidget {
  const AddCarbonButton({
    Key? key,
    required this.enabled,
    required this.onPressed,
  }) : super(key: key);

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return QuimifyButton(
      height: 40,
      backgroundColor: quimifyTeal,
      enabled: enabled,
      onPressed: onPressed,
      child: Image.asset(
        'assets/images/icons/bond-carbon.png',
        color: Theme.of(context).colorScheme.onPrimary,
        width: 26,
      ),
    );
  }
}
