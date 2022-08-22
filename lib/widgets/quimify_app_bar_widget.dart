import 'package:cliente/widgets/quimify_icon_widget.dart';
import 'package:flutter/material.dart';

class QuimifyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QuimifyAppBar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: const [QuimifyIcon()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(57);
}
