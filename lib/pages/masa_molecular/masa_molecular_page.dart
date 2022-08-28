import 'package:flutter/material.dart';

import 'package:cliente/widgets/home_app_bar.dart';
import 'package:cliente/constants.dart' as constants;

class MasaMolecularPage extends StatelessWidget {
  const MasaMolecularPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: constants.quimifyGradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            HomeAppBar(
              title: Text(
                'Masa molecular',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                decoration: constants.bodyBoxDecoration,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
