import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class InorganicResultField extends StatelessWidget {
  const InorganicResultField({
    Key? key,
    required this.title,
    required this.quantity,
    required this.unit,
    required this.titleAutoSizeGroup,
  }) : super(key: key);

  final String title;
  final String? quantity;
  final String unit;
  final AutoSizeGroup titleAutoSizeGroup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (quantity != null) ...[
          AutoSizeText(
            title,
            maxLines: 1,
            stepGranularity: 0.1,
            group: titleAutoSizeGroup,
            style: TextStyle(
              color: QuimifyColors.primary(context),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          AutoSizeText(
            '$quantity $unit',
            maxLines: 1,
            stepGranularity: 0.1,
            style: TextStyle(
              color: QuimifyColors.primary(context),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
