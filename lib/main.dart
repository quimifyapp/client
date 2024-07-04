import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/internet/api/api.dart';
import 'package:quimify_client/internet/api/results/client_result.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/molecular_mass_page.dart';
import 'package:quimify_client/pages/home/home_page.dart';
import 'package:quimify_client/pages/inorganic/nomenclature/nomenclature_page.dart';
import 'package:quimify_client/pages/organic/finding_formula/finding_formula_page.dart';
import 'package:quimify_client/pages/organic/naming/naming_page.dart';
import 'package:quimify_client/routes.dart';
import 'package:quimify_client/storage/storage.dart';
import 'package:quimify_client/pages/sign-in/sign_in_page.dart';

import 'internet/api/sign-in/google_sign_in_api.dart';

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

  GoogleSignInAccount? user = await GoogleSignInApi.loginSilently();
  ClientResult? clientResult = await Api().getClient();

  Ads().initialize(clientResult);

  runApp(
    DevicePreview(
      enabled: false, // !kReleaseMode,
      builder: (context) => QuimifyApp(
        clientResult: clientResult,
        user: user,
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
    required this.user,
  }) : super(key: key);

  final ClientResult? clientResult;
  final GoogleSignInAccount? user;

  @override
  Widget build(BuildContext context) {
    // To get rid of status bar's tint:
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: MaterialApp(
        title: 'Quimify',
        home: user != null ? HomePage(clientResult: clientResult, user: user) : SignInPage(clientResult: clientResult,),
        routes: {
          Routes.inorganicNomenclature: (context) => const NomenclaturePage(),
          Routes.organicNaming: (context) => const NamingPage(),
          Routes.organicFindingFormula: (context) => const FindingFormulaPage(),
          Routes.calculatorMolecularMass: (context) => const MolecularMassPage(),
        },
        // To get rid of debug banner:
        debugShowCheckedModeBanner: false,
        // To ignore device's font scaling factor:
        builder: (context, child) {
          child = EasyLoading.init()(context, child);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
            ),
            // To fix a single overscroll behavior across al platforms:
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(
                overscroll: false,
              ),
              child: child,
            ),
          );
        },
        theme: ThemeData(
          useMaterial3: false,
          brightness: Brightness.light,
          fontFamily: 'CeraPro',
        ),
        darkTheme: ThemeData(
          useMaterial3: false,
          brightness: Brightness.dark,
          fontFamily: 'CeraPro',
        ),
      ),
    );
  }
}
