import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

const double _breakpointSize = 360;

/// If we need to add more endpoints for tablet or desktop, we can do it here.
/// There are already some predefined options, such as:
/// const String MOBILE = 'MOBILE';
/// const String TABLET = 'TABLET';
/// const String PHONE = 'PHONE';
/// const String DESKTOP = 'DESKTOP';

const String extraSmall = 'EXTRA_SMALL';

const List<Breakpoint> responsiveBreakpoints = [
  Breakpoint(
    start: 0,
    end: _breakpointSize,
    name: extraSmall,
  ),
  Breakpoint(
    start: _breakpointSize + 1,
    end: double.infinity,
    name: MOBILE,
  ),
];

extension QuimifyResponsiveExtensions on BuildContext {
  T? responsiveSmallSelector<T>({
    required T defaultValue,
    required T extraSmallValue,
  }) {
    return ResponsiveValue<T>(
      this,
      defaultValue: defaultValue,
      conditionalValues: [
        Condition.smallerThan(
          value: extraSmallValue,
          name: MOBILE,
        )
      ],
    ).value;
  }

  /// With the scrollController set, the list won't be able to fetch the main scroll controller
  /// and the hidding of the header while scrolling won't work.
  ScrollController? responsiveScrollController(
      ScrollController scrollController) {
    return ResponsiveValue<ScrollController?>(
      this,
      defaultValue: null,
      conditionalValues: [
        Condition.largerThan(
          value: scrollController,
          name: extraSmall,
        )
      ],
    ).value;
  }

}
