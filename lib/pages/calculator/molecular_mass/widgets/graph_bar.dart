import 'dart:math';

import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:flutter/material.dart';

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
        color: Theme.of(context).colorScheme.onSecondary,
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
            color: quimifyTeal,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
