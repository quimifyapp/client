import 'package:cliente/pages/formulacion/pages/inorganica/inorganica_page.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_box_decoration.dart';
import '../../widgets/gradient_box_decoration.dart';
import '../../widgets/page_app_bar.dart';

class FormulacionPage extends StatelessWidget {
  const FormulacionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // App bar:
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Row(
                      children: [
                        // Icon
                        // SizedBox(width: 20),
                        Text(
                          'Formulación',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  decoration: bodyBoxDecoration,
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return const InorganicaPage();
                                },
                              ),
                            );
                          },
                          child: const Text('Inorgánica')),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Formular')),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Simple')),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Éter')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
