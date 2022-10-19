import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class QuimifySearchCompletion extends StatelessWidget {
  const QuimifySearchCompletion({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Icon(
              Icons.subdirectory_arrow_right_rounded,
              size: 26,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: AutoSizeText(
                text,
                maxLines: 1,
                stepGranularity: 0.1,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
