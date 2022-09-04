import 'package:cliente/widgets/page_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:cliente/widgets/search_bar.dart';
import 'package:cliente/constants.dart';

import '../../../utils/text.dart';
import '../../../widgets/button.dart';

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
                  padding:
                      EdgeInsets.only(top: 30, bottom: 5, left: 25, right: 25),
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
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 14,
                ),
              ),
              Text(
                'ácido sulfúrico',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
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
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 5),
                child: const Text(
                  'H₂SO₄',
                  style: TextStyle(
                    color: quimifyTeal,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 5),
                child: const Text(
                  'ácido sulfúrico',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: quimifyTeal.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: SearchResultQuantity(
                            title: 'Masa',
                            quantity: '18.01',
                            unit: 'g/mol',
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 50,
                          child: SearchResultQuantity(
                            title: 'Densidad',
                            quantity: '4.0012',
                            unit: 'g/cm³',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: SearchResultQuantity(
                            title: 'P. de fusión',
                            quantity: '273.15',
                            unit: 'K',
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 50,
                          child: SearchResultQuantity(
                            title: 'P. de ebullición',
                            quantity: '143.27',
                            unit: 'K',
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SearchResultButton(
                      color: const Color.fromARGB(255, 255, 96, 96),
                      backgroundColor: const Color.fromARGB(255, 255, 241, 241),
                      icon: Image.asset(
                        'assets/images/icons/report.png',
                        color: const Color.fromARGB(255, 255, 96, 96),
                        width: 18,
                      ),
                      text: 'Reportar',
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: SearchResultButton(
                      color: Color.fromARGB(255, 56, 133, 224),
                      backgroundColor: Color.fromARGB(255, 239, 246, 253),
                      icon: Icon(
                        Icons.share_outlined,
                        color: Color.fromARGB(255, 56, 133, 224),
                        size: 18,
                      ),
                      text: 'Compartir',
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}

class SearchResultQuantity extends StatelessWidget {
  const SearchResultQuantity(
      {Key? key,
      required this.title,
      required this.quantity,
      required this.unit})
      : super(key: key);

  final String title, quantity, unit;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            '$quantity $unit',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
    );
  }
}

class SearchResultButton extends StatelessWidget {
  const SearchResultButton(
      {Key? key,
      required this.icon,
      required this.text,
      required this.color,
      required this.backgroundColor})
      : super(key: key);

  final Widget icon;
  final String text;
  final Color color, backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Button(
      width: 50,
      color: backgroundColor,
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          icon,
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 16,
              //fontWeight: FontWeight.bold
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
