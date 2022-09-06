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
