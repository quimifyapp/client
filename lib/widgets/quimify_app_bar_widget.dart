import 'package:flutter/material.dart';

class QuimifyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QuimifyAppBar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(title),
      foregroundColor: Colors.white,
      leading: Ink(
          child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop()),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 106, 233, 218),
              borderRadius: BorderRadius.circular(10))),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(57);
}
