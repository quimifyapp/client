import 'package:flutter/material.dart';

bool _hasLightMode(context) =>
    MediaQuery.of(context).platformBrightness == Brightness.light;

Color _themedColor(context, {required Color light, required Color dark}) =>
    _hasLightMode(context) ? light : dark;

class QuimifyColors {
  static LinearGradient gradient({double opacity = 1}) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          const Color.fromARGB(255, 55, 224, 211).withOpacity(opacity),
          const Color.fromARGB(255, 72, 232, 167).withOpacity(opacity),
        ],
      );

  static Color teal() => const Color.fromARGB(255, 59, 226, 199);

  static Color secondaryTeal(BuildContext context) => _themedColor(
        context,
        light: const Color.fromARGB(255, 106, 233, 218),
        dark: const Color.fromARGB(255, 118, 252, 237),
      );

  static Color primary(BuildContext context) => _themedColor(
        context,
        light: const Color.fromARGB(255, 34, 34, 34),
        dark: Colors.white,
      );

  static Color secondary(BuildContext context) => _themedColor(
        context,
        light: Colors.black45,
        dark: Colors.white60,
      );

  static Color tertiary(BuildContext context) => _themedColor(
        context,
        light: Colors.black12,
        dark: Colors.white54,
      );

  static Color quaternary(BuildContext context) => _themedColor(
        context,
        light: const Color.fromARGB(255, 150, 150, 150),
        dark: Colors.white60,
      );

  static Color foreground(BuildContext context) => _themedColor(
        context,
        light: Colors.white,
        dark: const Color.fromARGB(255, 30, 30, 30),
      );

  static Color background(BuildContext context) => _themedColor(
        context,
        light: const Color.fromARGB(255, 247, 247, 247),
        dark: const Color.fromARGB(255, 18, 18, 18),
      );

  static Color inverseText(BuildContext context) => _themedColor(
        context,
        light: Colors.white,
        dark: const Color.fromARGB(255, 18, 18, 18),
      );

  static Color textHighlight(BuildContext context) => _themedColor(
        context,
        light: const Color.fromARGB(255, 244, 255, 249),
        dark: const Color.fromARGB(255, 7, 56, 53),
      );

  static Color onRedText(BuildContext context) => _themedColor(
        context,
        light: const Color.fromARGB(255, 255, 96, 96),
        dark: const Color.fromARGB(255, 18, 18, 18),
      );

  static Color redBackground(BuildContext context) => _themedColor(
        context,
        light: const Color.fromARGB(255, 255, 241, 241),
        dark: const Color.fromARGB(255, 255, 96, 96),
      );

  static Color onBlueText(BuildContext context) => _themedColor(
        context,
        light: const Color.fromARGB(255, 56, 133, 224),
        dark: const Color.fromARGB(255, 18, 18, 18),
      );

  static Color blueBackground(BuildContext context) => _themedColor(
        context,
        light: const Color.fromARGB(255, 239, 246, 253),
        dark: const Color.fromARGB(255, 56, 133, 224),
      );

  static Color dialogBackdrop(BuildContext context) => _themedColor(
        context,
        light: const Color.fromARGB(150, 0, 0, 0),
        dark: const Color.fromARGB(175, 0, 0, 0),
      );

  static Color diagramBackground(BuildContext context) => _themedColor(
        context,
        light: const Color.fromARGB(255, 255, 255, 255),
        dark: const Color.fromARGB(255, 10, 10, 10),
      );

  static Color chartBackground(BuildContext context) => _themedColor(
        context,
        light: const Color.fromARGB(255, 231, 246, 247),
        dark: const Color.fromARGB(255, 10, 38, 34),
      );

  static Color chartBarBackground(BuildContext context) => _themedColor(
        context,
        light: const Color.fromARGB(13, 0, 0, 0),
        dark: Colors.black45,
      );

  static Color diagram3dButton(BuildContext context) => _themedColor(
        context,
        light: const Color.fromARGB(255, 56, 133, 224),
        dark: const Color.fromARGB(255, 56, 133, 224),
      );

  static Color periodicTableHeader(BuildContext context) => _themedColor(
        context,
        light: Colors.grey.shade200,
        dark: const Color(0xFF323232),
      );

  static Color reactiveNonMetal() => const Color(0xff6C2CC2);

  static Color reactiveNonMetalLight() => const Color(0xffDFCDF6);

  static Color transitionMetal() => const Color(0xff454ADE);

  static Color transitionMetalLight() => const Color(0xffDADBF8);

  static Color halogene() => const Color(0xff24928C);

  static Color halogeneLight() => const Color(0xffD3E9E8);

  static Color postTransitionMetal() => const Color(0xff1D8448);

  static Color postTransitionMetalLight() => const Color(0xffC4F5D7);

  static Color lanthanide() => const Color(0xff6B5257);

  static Color lanthanideLight() => const Color(0xffE1E1E1);

  static Color nobleGas() => const Color(0xff6F673E);

  static Color nobleGasLight() => const Color(0xffFFEBC1);

  static Color metalloid() => const Color(0xffCC6D16);

  static Color metalloidLight() => const Color(0xffFFDEBE);

  static Color actinide() => const Color(0xffC03F47);

  static Color actinideLight() => const Color(0xffFFCED1);

  static Color alkalineEarthMetal() => const Color(0xffB84789);

  static Color alkalineEarthMetalLight() => const Color(0xffF6BEE0);

  static Color alkaliMetal() => const Color(0xff83499F);

  static Color alkaliMetalLight() => const Color(0xffECC5FB);
}
