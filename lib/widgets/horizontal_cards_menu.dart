import 'package:flutter/material.dart';

import 'menu_card.dart';

class HorizontalCardsMenu extends StatelessWidget {
  const HorizontalCardsMenu({Key? key, required this.cards}) : super(key: key);

  final List<MenuCard> cards;

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