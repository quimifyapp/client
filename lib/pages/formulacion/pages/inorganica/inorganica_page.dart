import 'package:cliente/widgets/body_box_decoration.dart';
import 'package:cliente/widgets/gradient_box_decoration.dart';
import 'package:cliente/widgets/page_app_bar.dart';
import 'package:cliente/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class InorganicaPage extends StatelessWidget {
  const InorganicaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              PageAppBar(title: 'Formulación inorgánica'),
              SearchBar(hint: 'Un nombre o fórmula'),
              Flexible(
                child: Container(
                  decoration: bodyBoxDecoration,
                  width: double.infinity,
                  child: Column(
                    children: [SizedBox(height: 28.8), SearchResult()],
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

class SearchResult extends StatelessWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 400,
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                  height: 40,
                  child: Row(
                    children: [
                      Text('Result of: '), Text('ácido sulfúrico')
                    ],
                  )),

        ],
      ),
    );
  }
}
