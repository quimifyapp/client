import 'package:cliente/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'calculator/calculator_page.dart';
import 'nomenclature/nomenclature_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // To ignore device's font scaling factor:
    MediaQueryData windowData =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    windowData = windowData.copyWith(textScaleFactor: 1.0);

    // So it's always vertical:
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MediaQuery(
      // To ignore device's font scaling factor:
      data: windowData,
      // To get rid of status bar's tint:
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: MaterialApp(
          // To ignore device's font scaling factor:
          useInheritedMediaQuery: true,
          // To get rid of debug banner:
          debugShowCheckedModeBanner: false,
          // To set stretched scroll on all Android versions: //TODO: deprecated
          scrollBehavior: const ScrollBehavior(
              androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
          // Theme:
          theme: ThemeData(
            fontFamily: 'CeraPro',
          ),
          // App:
          title: 'Quimify',
          home: const MainPage(),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;

  List<Widget> pages = [const NomenclaturePage(), const CalculatorPage()];

  static double widthFactor = 0.85;

  void _goToPage(int page) {
    if (currentPage != page) {
      setState(() {
        currentPage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizedBox navigationBarItemSeparator = SizedBox(
      width: MediaQuery.of(context).size.width * 0.01 + 4,
    );

    return Scaffold(
      // Body:
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      // Navigation bar:
      extendBody: true, // So it's always floating on top
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FractionallySizedBox(
          widthFactor: widthFactor,
          child: GestureDetector(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: quimifyGradient,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                    color: const Color.fromARGB(255, 245, 247, 251),
                    width: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/icons/molecule.png',
                        width: 20,
                        color: currentPage == 0 ? Colors.white : Colors.white70,
                      ),
                      navigationBarItemSeparator,
                      Text(
                        'Formulación',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color:
                              currentPage == 0 ? Colors.white : Colors.white70,
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
                        color: currentPage == 1 ? Colors.white : Colors.white70,
                      ),
                      navigationBarItemSeparator,
                      Text(
                        'Calculadora',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color:
                              currentPage == 1 ? Colors.white : Colors.white70,
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
    );
  }
}
