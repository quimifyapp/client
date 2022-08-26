import 'package:cliente/widgets/page_app_bar.dart';
import 'package:cliente/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class InorganicaPage extends StatelessWidget {
  const InorganicaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
            Color.fromARGB(255, 68, 226, 220),
            Color.fromARGB(255, 67, 230, 166)
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Center(
                child: Column(
          children: [
            Container(
              // App bar and search zone:
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                children: [
                  PageAppBar(title: 'Formulación inorgánica'),
                  SearchBar(hint: 'Nombre o fórmula'),
                ],
              ),
            ),
            Container(
              // Body:
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 245, 247, 251),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
              width: double.infinity,
              height: 500,
            ),
          ],
        ))),
      ),
    );
  }
}
