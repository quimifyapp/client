import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/internet/api/api.dart';
import 'package:quimify_client/internet/api/results/client_result.dart';
import 'package:quimify_client/internet/payments/payments.dart';
import 'package:quimify_client/pages/accounts/sign_in_page.dart';
import 'package:quimify_client/pages/calculator/equation/equation_page.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/molecular_mass_page.dart';
import 'package:quimify_client/pages/home/home_page.dart';
import 'package:quimify_client/pages/inorganic/nomenclature/nomenclature_page.dart';
import 'package:quimify_client/pages/organic/finding_formula/finding_formula_page.dart';
import 'package:quimify_client/pages/organic/naming/naming_page.dart';
import 'package:quimify_client/routes.dart';
import 'package:quimify_client/storage/storage.dart';

main() async {
  _showLoadingScreen();
  await _loadApp();
  _hideLoadingScreen();
}

_loadApp() async {
  await _loadRootCertificateNotPresentInOlderDevices();
  ClientResult? clientResult = await _initializeDependencies();

  runApp(
    DevicePreview(
      enabled: false, // !kReleaseMode,
      builder: (context) => QuimifyApp(
        clientResult: clientResult,
      ),
    ),
  );
}

_showLoadingScreen() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
}

_hideLoadingScreen() => FlutterNativeSplash.remove();

_loadRootCertificateNotPresentInOlderDevices() async {
  try {
    var certificate = await rootBundle.load('assets/ssl/isrg-x1.crt');
    var bytes = certificate.buffer.asUint8List();
    SecurityContext.defaultContext.setTrustedCertificatesBytes(bytes);
  } catch (_) {}
}

Future<ClientResult?> _initializeDependencies() async {
  Api().initialize();

  List<Future> futures = [
    Api().getClient(),
    Storage().initialize(),
    Payments().initialize(),
  ];

  await futures.wait;

  ClientResult? clientResult = await futures[0];

  Ads().initialize(clientResult);

  return clientResult;
}

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
        // TODO: If user signed in, show HomePage
        // home: HomePage(clientResult: clientResult),
        home: const SignInPage(),
        routes: {
          Routes.inorganicNomenclature: (context) => const NomenclaturePage(),
          Routes.organicNaming: (context) => const NamingPage(),
          Routes.organicFindingFormula: (context) => const FindingFormulaPage(),
          Routes.calculatorMolecularMass: (context) =>
              const MolecularMassPage(),
          Routes.calculatorEquation: (context) => const EquationPage(),
          Routes.signIn: (context) => const SignInPage(),
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
