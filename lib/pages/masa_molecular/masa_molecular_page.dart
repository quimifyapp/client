import 'package:flutter/material.dart';

import '../../widgets/body_box_decoration.dart';
import '../../widgets/gradient_box_decoration.dart';
import '../../widgets/home_app_bar.dart';

class MasaMolecularPage extends StatelessWidget {
  const MasaMolecularPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              HomeAppBar(title: 'Masa molecular'),
              Flexible(
                child: Container(
                  decoration: bodyBoxDecoration,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
