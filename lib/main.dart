import 'dart:developer';
import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:quimify_client/firebase_options.dart';
import 'package:quimify_client/internet/accounts/accounts.dart';
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ClientResult? clientResult = await _initializeDependencies();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

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

  // Initialize Payments first
  try {
    await Payments().initialize();
  } catch (e) {
    log('Failed to initialize payments: $e');
    rethrow;
  }

  List<Future> futures = [
    Api().getClient(),
    Storage().initialize(),
    AuthService().initialize(),
  ];

  final results = await Future.wait(futures);

  final ClientResult? clientResult = results[0] as ClientResult?;

  Ads().initialize(clientResult);

  return clientResult;
}

class QuimifyApp extends StatefulWidget {
  const QuimifyApp({
    Key? key,
    this.clientResult,
  }) : super(key: key);

  final ClientResult? clientResult;

  @override
  State<QuimifyApp> createState() => _QuimifyAppState();
}

class _QuimifyAppState extends State<QuimifyApp> {
  late bool _isInitialized = false;
  late Widget _initialScreen;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authService = AuthService();

    // Determine the initial screen based on auth status
    if (authService.isSignedIn || authService.hasSkippedLogin) {
      _initialScreen = HomePage(clientResult: widget.clientResult);
    } else {
      _initialScreen = SignInPage(clientResult: widget.clientResult);
    }

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: MaterialApp(
        title: 'Quimify',
        home: _initialScreen,
        routes: {
          Routes.inorganicNomenclature: (context) => const NomenclaturePage(),
          Routes.organicNaming: (context) => const NamingPage(),
          Routes.organicFindingFormula: (context) => const FindingFormulaPage(),
          Routes.calculatorMolecularMass: (context) =>
              const MolecularMassPage(),
          Routes.calculatorEquation: (context) => const EquationPage(),
          Routes.signIn: (context) => SignInPage(
                clientResult: widget.clientResult,
              ),
        },
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          child = EasyLoading.init()(context, child);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
            ),
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
