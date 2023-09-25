import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// For everything related to responsive design and responsive_framework library.
class QuimifyResponsiveUtils {
  /// Name for custom Breakpoint.
  static const String smallest = 'EXTRA_SMALL';

  /// Responsive breakpoints for the app.
  /// If we need to add more endpoints for tablet or desktop, we can do it here.
  ///
  /// There are already some predefined options at "responsive_breakpoints.dart", such as:
  /// const String MOBILE = 'MOBILE';
  /// const String TABLET = 'TABLET';
  /// const String PHONE = 'PHONE';
  /// const String DESKTOP = 'DESKTOP';
  ///
  static const List<Breakpoint> responsiveBreakpoints = [
    /// Smallest device
    Breakpoint(
      start: 0,
      end: 360,
      name: QuimifyResponsiveUtils.smallest,
    ),

    /// Mobile size and upwards
    Breakpoint(
      start: 361,
      end: double.infinity,
      name: MOBILE,
    ),
  ];
}

/// Helper extension for [ResponsiveValue].
extension QuimifyResponsiveUtilsExtensions on BuildContext {
  /// Picks between two values based on the device's size.
  T? whenSmallDevice<T>({
    required T defaultValue,
    required T extraSmallValue,
  }) {
    return ResponsiveValue<T>(
      this,
      defaultValue: defaultValue,
      conditionalValues: [
        Condition.smallerThan(
          value: extraSmallValue,
          name: QuimifyResponsiveUtils.smallest,
        )
      ],
    ).value;
  }
}
