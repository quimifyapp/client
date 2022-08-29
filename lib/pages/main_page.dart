import 'package:flutter/material.dart';

import '../widgets/constants.dart';
import 'formulacion/formulacion_page.dart';
import 'calculadora/calculadora_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;
  List<Widget> pages = const [FormulacionPage(), CalculadoraPage()];

  static double widthFactor = 0.85;

  void _goToPage(int page) {
    if (currentPage != page)
      setState(() {
        currentPage = page;
      });
  }

  @override
  Widget build(BuildContext context) {
    SizedBox navigationBarItemSeparator = SizedBox(
      width: MediaQuery.of(context).size.width * 0.01 + 4,
    );

    return Container(
      child: Scaffold(
        // Body:
        body: pages[currentPage],
        // Navigation bar:
        extendBody: true, // So it's always floating on top
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 50),
          child: FractionallySizedBox(
            widthFactor: widthFactor,
            child: GestureDetector(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: quimifyGradient,
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                      color: Color.fromARGB(255, 245, 247, 251), width: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/icons/molecule.png',
                          width: 20,
                          color:
                          currentPage == 0 ? Colors.white : Colors.white70,
                        ),
                        navigationBarItemSeparator,
                        Text(
                          'Formulación',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: currentPage == 0
                                ? Colors.white
                                : Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      width: 0.5,
                      color: Colors.white,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/icons/calculator.png',
                          width: 20,
                          color:
                          currentPage == 1 ? Colors.white : Colors.white70,
                        ),
                        navigationBarItemSeparator,
                        Text(
                          'Calculadora',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: currentPage == 1
                                ? Colors.white
                                : Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              onTapDown: (details) {
                double width = MediaQuery.of(context).size.width * widthFactor;
                _goToPage(details.localPosition.dx < width * 0.5 ? 0 : 1);
              },
            ),
          ),
        ),
      ),
    );
  }
}
