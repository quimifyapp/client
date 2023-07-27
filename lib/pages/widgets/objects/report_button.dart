import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';

class ReportButton extends StatelessWidget {
  const ReportButton({
    Key? key,
    required this.height,
    required this.size,
    required this.onPressed,
  }) : super(key: key);

  final double height;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return QuimifyIconButton.square(
      height: height,
      backgroundColor: Theme.of(context).colorScheme.error,
      onPressed: onPressed,
      icon: Image.asset(
        'assets/images/icons/report.png',
        width: size,
        color: Theme.of(context).colorScheme.onError,
      ),
    );
  }
}
