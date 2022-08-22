import 'package:cliente/pages/formulacion/pages/inorganica/inorganica_page.dart';
import 'package:cliente/widgets/quimify_app_bar_widget.dart';
import 'package:flutter/material.dart';

class FormulacionPage extends StatelessWidget {
  const FormulacionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const QuimifyAppBar(title: 'Formulación'),
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const InorganicaPage();
                    },
                  ));
                },
                child: const Text('Inorgánica')),
            ElevatedButton(onPressed: () {}, child: const Text('Formular')),
            ElevatedButton(onPressed: () {}, child: const Text('Simple')),
            ElevatedButton(onPressed: () {}, child: const Text('Éter')),
          ],
        )));
  }
}
