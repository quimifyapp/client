import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/internet/api/api.dart';
import 'package:quimify_client/internet/api/results/client_result.dart';
import 'package:quimify_client/pages/home/home_page.dart';
import 'package:quimify_client/storage/storage.dart';

main() async {
  _showLoadingScreen();

  await Storage().initialize();
  Api().initialize();

  try {
    // Sets ISRG Root X1 certificate, not present in Android < 25
    var certificate = await rootBundle.load('assets/ssl/isrg-x1.crt');
    var bytes = certificate.buffer.asUint8List();
    SecurityContext.defaultContext.setTrustedCertificatesBytes(bytes);
  } catch (_) {} // It's already present in modern devices anyways

  ClientResult? clientResult = await Api().getClient();

  Ads().initialize(clientResult);

  runApp(
    DevicePreview(
      enabled: false, // !kReleaseMode,
      builder: (context) => QuimifyApp(
        clientResult: clientResult,
      ), // Wrap your app
    ),
  );

  _hideLoadingScreen();
}

_showLoadingScreen() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
}

_hideLoadingScreen() => FlutterNativeSplash.remove();

class QuimifyApp extends StatelessWidget {
  const QuimifyApp({
    Key? key,
    this.clientResult,
  }) : super(key: key);

  final ClientResult? clientResult;

  @override
  Widget build(BuildContext context) {
    // To get rid of status bar's tint:
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: MaterialApp(
        title: 'Quimify',
        home: HomePage(clientResult: clientResult),
        routes: {
          "/home": (context) => HomePage(accessDataResult: accessDataResult),
          // Inorganic
          "/inorganic": (context) => InorganicPage(),
          "/nomenclature": (context) => NomenclaturePage(),
          // Organic
          "/organic": (context) => OrganicPage(),
          "/naming": (context) => NamingPage(),
          "/finding_formula": (context) => FindingFormulaPage(),
          // MolecularMass
          "/molecular_mass": (context) => CalculatorPage(),
          "/molecular_mass_result": (context) => MolecularMassPage(),
        },
        // To get rid of debug banner:
        debugShowCheckedModeBanner: false,
        // To set stretched scroll on all Android versions:
        scrollBehavior: const ScrollBehavior(
          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
        ),
        // To ignore device's font scaling factor:
        builder: (context, child) {
          child = EasyLoading.init()(context, child);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child,
          );
        },
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: 'CeraPro',
          colorScheme: const ColorScheme(
            brightness: Brightness.light,

            primary: Color.fromARGB(255, 34, 34, 34),
            secondary: Colors.black12,
            tertiary: Colors.black45,
            tertiaryContainer: Color.fromARGB(255, 150, 150, 150),
            // Top bar disabled text

            surface: Colors.white,
            background: Color.fromARGB(255, 247, 247, 247),

            onPrimary: Colors.white,
            // White text
            onPrimaryContainer: Color.fromARGB(255, 220, 220, 220),
            // Unselected text

            onBackground: Color.fromARGB(255, 231, 246, 247),
            // Graph background
            onSecondary: Color.fromARGB(13, 0, 0, 0),
            // Graph bar background
            onSurface: Color.fromARGB(255, 244, 255, 249),
            // Inorganic amounts

            shadow: Color.fromARGB(150, 0, 0, 0),
            // Dialog barrier
            inverseSurface: Color.fromARGB(255, 60, 60, 60),
            // Lock icon

            onError: Color.fromARGB(255, 255, 96, 96),
            // Error text
            error: Color.fromARGB(255, 255, 241, 241),
            // Background
            onErrorContainer: Color.fromARGB(255, 56, 133, 224),
            // Share text
            errorContainer: Color.fromARGB(255, 239, 246, 253),
            // Background

            surfaceTint: Color.fromARGB(255, 255, 255, 255),
            // Diagram background

            onTertiaryContainer: Color.fromARGB(255, 106, 233, 218), // [<-]
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'CeraPro',
          colorScheme: const ColorScheme(
            brightness: Brightness.dark,

            primary: Colors.white,
            secondary: Colors.white54,
            tertiary: Colors.white60,
            tertiaryContainer: Colors.white60,
            // Top bar disabled text

            surface: Color.fromARGB(255, 30, 30, 30),
            background: Color.fromARGB(255, 18, 18, 18),

            onPrimary: Color.fromARGB(255, 18, 18, 18),
            // Black text
            onPrimaryContainer: Color.fromARGB(255, 90, 90, 90),
            // Unselected text

            onBackground: Color.fromARGB(255, 10, 38, 34),
            // Graph background
            onSecondary: Colors.black45,
            // Graph bar background
            onSurface: Color.fromARGB(255, 7, 56, 53),
            // Inorganic amounts

            shadow: Color.fromARGB(175, 0, 0, 0),
            // Dialog barrier
            inverseSurface: Color.fromARGB(255, 235, 235, 235),
            // Lock icon

            onError: Color.fromARGB(255, 18, 18, 18),
            // Black text
            // Error color
            error: Color.fromARGB(255, 255, 96, 96),
            // Background
            onErrorContainer: Color.fromARGB(255, 18, 18, 18),
            // Black text
            // Share color
            errorContainer: Color.fromARGB(255, 56, 133, 224),
            // Background

            surfaceTint: Color.fromARGB(255, 10, 10, 10),
            // Diagram background

            onTertiaryContainer: Color.fromARGB(255, 118, 252, 237), // [<-]
          ),
        ),
      ),
    );
  }
}
