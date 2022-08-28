import 'package:cliente/pages/formulacion/formulacion_page.dart';
import 'package:cliente/pages/masa_molecular/masa_molecular_page.dart';
import 'package:cliente/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      child: MaterialApp(
        title: 'Quimify',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'CeraPro',
        ),
        scrollBehavior: const ScrollBehavior(
            //TODO: deprecated y font size
            androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
        home: const RootPage(),
      ),
      // To get rid of status bar's tint:
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List<Widget> pages = const [FormulacionPage(), MasaMolecularPage()];

  void _goToPage(int page) {
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
            widthFactor: 0.85,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                //color: constants.quimifyTeal,
                gradient: constants.quimifyGradient,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                    color: Color.fromARGB(255, 245, 247, 251), width: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Row(
                      children: [
                        Icon(
                          Icons.share_outlined,
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
                    onTap: () {
                      _goToPage(0);
                    },
                  ),
                  Container(
                    height: 40,
                    width: 0.5,
                    color: Colors.white,
                  ),
                  InkWell(
                    child: Row(
                      children: [
                        Icon(
                          Icons.calculate_outlined,
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
                    onTap: () {
                      _goToPage(1);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
