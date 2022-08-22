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
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                    child: TextField(
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      prefixIcon: IconButton(
                          icon: const Icon(Icons.camera_alt_rounded),
                          onPressed: () {}),
                      border: const OutlineInputBorder(),
                      labelText: 'Nombre o fórmula'),
                )),
                ElevatedButton(
                    onPressed: () {}, child: const Icon(Icons.search)),
              ],
            ),
          ],
        )));
  }
}
