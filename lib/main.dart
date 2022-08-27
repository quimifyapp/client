import 'package:cliente/pages/formulacion/formulacion_page.dart';
import 'package:cliente/pages/masa_molecular/masa_molecular_page.dart';
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
          primaryColor: Color.fromARGB(255, 34, 34, 34),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: pages[0],
      ),
    );
  }
}
