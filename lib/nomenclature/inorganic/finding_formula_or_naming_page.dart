import 'package:cliente/widgets/page_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:cliente/widgets/search_bar.dart';
import 'package:cliente/widgets/constants.dart';

import '../../utils/text.dart';

class FindingFormulaOrNamingPage extends StatelessWidget {
  const FindingFormulaOrNamingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: quimifyGradientBoxDecoration,
      child: Scaffold(
        // To avoid keyboard resizing:
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const PageAppBar(title: 'Formulación inorgánica'),
            SearchBar(
              hint: 'NaCl, óxido de hierro...',
              corrector: (String input) => formatInorganicFormulaOrName(input),
            ),
            // Body:
            Expanded(
              child: Container(
                decoration: bodyBoxDecoration,
                // To avoid rounded corners overflow:
                clipBehavior: Clip.hardEdge,
                child: const SingleChildScrollView(
                  padding: EdgeInsets.only(top: 30, bottom: 5, left: 25, right: 25),
                  child: SearchResults(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResults extends StatefulWidget {
  const SearchResults({Key? key}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  List<SearchResult> results = [
    const SearchResult(),
    const SearchResult(),
    const SearchResult(),
    const SearchResult(),
    const SearchResult(),
    const SearchResult(),
    const SearchResult(),
    const SearchResult(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: results,
    );
  }
}

class SearchResult extends StatelessWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          padding: const EdgeInsets.all(15),
          child: Row(
            children: const [
              Text(
                'Búsqueda: ',
                style: TextStyle(color: Colors.black38),
              ),
              Text('ácido sulfúrico'),
            ],
          ),
        ),
        const SizedBox(height: 3),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: const [
              Text('Result of: ', style: TextStyle(fontSize: 20)),
              Text('ácido sulfúrico', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
