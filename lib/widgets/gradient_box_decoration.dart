import 'package:flutter/material.dart';

const BoxDecoration gradientBoxDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color.fromARGB(255, 55, 224, 211),
      Color.fromARGB(255, 72, 232, 167),
    ],
  ),
);
