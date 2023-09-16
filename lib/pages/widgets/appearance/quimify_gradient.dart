import 'package:flutter/material.dart';

LinearGradient quimifyGradient({double opacity = 1}) => LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    const Color.fromARGB(255, 55, 224, 211).withOpacity(opacity),
    const Color.fromARGB(255, 72, 232, 167).withOpacity(opacity),
  ],
);
