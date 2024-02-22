import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class DialogContentText extends StatelessWidget {
  const DialogContentText({
    Key? key,
    required this.text,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  final String text;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: QuimifyColors.primary(context),
        fontSize: 16,
        fontWeight: fontWeight,
      ),
      strutStyle: const StrutStyle(height: 1.5),
    );
  }
}
