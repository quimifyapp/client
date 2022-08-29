import 'package:cliente/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        value: SystemUiOverlayStyle(
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
