import 'package:flutter/material.dart';

const Color quimifyTeal = Color.fromARGB(255, 59, 226, 199);

const BoxDecoration quimifyGradientBoxDecoration = BoxDecoration(
  gradient: quimifyGradient,
);

const LinearGradient quimifyGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color.fromARGB(255, 55, 224, 211),
    Color.fromARGB(255, 72, 232, 167),
  ],
);

ColorFilter identityFilter = const ColorFilter.matrix(
  [
    1, 0, 0, 0, 0, //
    0, 1, 0, 0, 0, //
    0, 0, 1, 0, 0, //
    0, 0, 0, 1, 0, //
  ],
);

ColorFilter inverseFilter = const ColorFilter.matrix(
  [
    -1, 0, 0, 0, 255, //
    0, -1, 0, 0, 255, //
    0, 0, -1, 0, 255, //
    0, 0, 0, 1, 0, //
  ],
);
