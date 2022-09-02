import 'package:flutter/material.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.help_outline, size: 22),
      // To remove padding:
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () {},
    );
  }
}
