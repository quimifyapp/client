import 'package:fast_rich_text/fast_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class DialogContentText extends StatelessWidget {
  const DialogContentText({
    Key? key,
    required this.richText,
  }) : super(key: key);

  final String richText;

  @override
  Widget build(BuildContext context) {
    return FastRichText(
      text: richText,
      textAlign: TextAlign.center,
      textStyle: TextStyle(
        fontSize: 16,
        fontFamily: 'CeraPro',
        color: QuimifyColors.primary(context),
      ),
      strutStyle: const StrutStyle(height: 1.5),
    );
  }
}
