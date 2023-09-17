import 'package:flutter/material.dart';

class QuimifyField extends StatelessWidget {
  const QuimifyField({
    Key? key,
    required this.title,
    required this.value,
    required this.titleColor,
  }) : super(key: key);

  final String title;
  final String value;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 16,
          ),
          strutStyle: const StrutStyle(
            fontSize: 16,
            height: 1.3,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
            fontFamily: 'CeraProBoldCustom',
          ),
          strutStyle: const StrutStyle(
            fontSize: 18,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
