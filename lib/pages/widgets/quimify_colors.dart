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

  static Color allBlue(BuildContext context) => _themedColor(
        context,
        light: const Color.fromARGB(255, 56, 133, 224),
        dark: const Color.fromARGB(255, 56, 133, 224)
      );
}
