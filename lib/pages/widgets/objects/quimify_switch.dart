import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:flutter/material.dart';

class QuimifySwitch extends StatelessWidget {
  const QuimifySwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      // Colors:
      activeTrackColor: quimifyTeal,
      inactiveTrackColor: Theme.of(context).colorScheme.secondary,
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
