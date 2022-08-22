import 'package:cliente/widgets/quimify_app_bar_widget.dart';
import 'package:flutter/material.dart';

class MasaMolecularPage extends StatelessWidget {
  const MasaMolecularPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: QuimifyAppBar(title: 'Masa molecular'));
  }
}
