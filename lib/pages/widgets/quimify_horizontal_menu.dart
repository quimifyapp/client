import 'package:cliente/pages/widgets/quimify_card.dart';
import 'package:flutter/material.dart';

class QuimifyHorizontalMenu extends StatelessWidget {
  const QuimifyHorizontalMenu({Key? key, required this.cards}) : super(key: key);

  final List<QuimifyCard> cards;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Wrap(
          spacing: 15,
          children: cards,
        ),
      ),
    );
  }
}
