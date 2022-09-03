import 'package:cliente/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'api/api.dart';
import 'api/results/access_result.dart';


late final AccessResult? accessResult;

Future<void> main() async {
  // Show splash screen UNTIL stated otherwise:
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Loading:
  accessResult = await Api().connect();

  // App launch:
  runApp(const QuimifyApp());
}

class QuimifyApp extends StatelessWidget {
  const QuimifyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // To ignore device's font scaling factor:
    MediaQueryData windowData =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    windowData = windowData.copyWith(textScaleFactor: 1.0);

    // So it's always vertical:
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // Hide splash screen:
    FlutterNativeSplash.remove();

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
          home: MainPage(accessResult: accessResult),
        ),
      ),
    );
  }
}
