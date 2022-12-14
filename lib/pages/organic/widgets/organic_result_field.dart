import 'package:flutter/material.dart';

class OrganicResultField extends StatelessWidget {
  const OrganicResultField({
    Key? key,
    required this.title,
    required this.field,
  }) : super(key: key);

  final String title, field;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
          strutStyle: const StrutStyle(
            fontSize: 16,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          field,
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
        const SizedBox(height: 15),
      ],
    );
  }
}
