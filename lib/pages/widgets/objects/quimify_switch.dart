import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class QuimifySwitch extends StatelessWidget {
  const QuimifySwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      // Colors:
      activeTrackColor: QuimifyColors.teal(),
      inactiveTrackColor: QuimifyColors.tertiary(context),
      activeColor: Colors.white,
      inactiveThumbColor: Colors.white,
      // To remove top padding:
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      // To remove splash:
      splashRadius: 0.0,
      // Logic:
      onChanged: (bool newValue) => onChanged(newValue),
      value: value,
    );
  }
}
