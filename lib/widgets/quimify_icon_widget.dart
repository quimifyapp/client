import 'package:flutter/material.dart';

class QuimifyIcon extends StatelessWidget {
  const QuimifyIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: const ImageIcon(
          AssetImage('images/icons/quimify_light.png'),
          color: Colors.white,
        ));
  }
}
