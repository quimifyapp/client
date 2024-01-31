import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class GraphBar extends StatelessWidget {
  const GraphBar({Key? key, required this.quantity, required this.total})
      : super(key: key);

  final num quantity, total;

  @override
  Widget build(BuildContext context) {
    double proportion = quantity / total;

    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: QuimifyColors.chartBarBackground(context),
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.centerLeft,
      // To avoid rounded corners overflow:
      clipBehavior: Clip.hardEdge,
      child: FractionallySizedBox(
        widthFactor: min(proportion, 1),
        child: Container(
          height: 10,
          decoration: BoxDecoration(
            color: QuimifyColors.teal(),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
