import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class InorganicResultName extends StatelessWidget {
  const InorganicResultName({
    Key? key,
    required this.label,
    required this.name,
  }) : super(key: key);

  final String label;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (name != null) ...[
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: QuimifyColors.teal(),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: QuimifyColors.textHighlight(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name!,
                  style: TextStyle(
                    color: QuimifyColors.primary(context),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
