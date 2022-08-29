import 'package:flutter/material.dart';

import 'package:cliente/widgets/home_app_bar.dart';
import 'package:cliente/widgets/constants.dart';

class CalculadoraPage extends StatelessWidget {
  const CalculadoraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: quimifyGradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            HomeAppBar(
              title: Text(
                'Calculadora',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                decoration: bodyBoxDecoration,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
