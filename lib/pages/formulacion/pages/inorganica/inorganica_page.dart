import 'package:flutter/material.dart';
import 'package:cliente/widgets/quimify_app_bar_widget.dart';

class InorganicaPage extends StatelessWidget {
  const InorganicaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const QuimifyAppBar(title: 'Inorgánica'),
        body: Center(
            child: Column(
          children: [
            const SizedBox(height: 25),
            const TextField(
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre o fórmula'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Buscar')),
                ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.camera_alt_rounded))
              ],
            )
          ],
        )));
  }
}
