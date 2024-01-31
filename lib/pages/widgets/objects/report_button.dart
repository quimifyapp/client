import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

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
      backgroundColor: QuimifyColors.redBackground(context),
      onPressed: onPressed,
      icon: Image.asset(
        'assets/images/icons/report.png',
        width: size,
        color: QuimifyColors.onRedText(context),
      ),
    );
  }
}
