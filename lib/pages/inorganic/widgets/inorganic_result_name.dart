import 'package:flutter/material.dart';

class InorganicResultName extends StatelessWidget {
  const InorganicResultName({
    Key? key,
    this.label,
    required this.name,
  }) : super(key: key);

  final String? label;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if (label != null) ...[
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.onSurface,
            ),
            child: Text(
              label!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
                fontSize: 14.5,
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
        Container(
          padding: const EdgeInsets.only(left: 6),
          child: Text(
            name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
