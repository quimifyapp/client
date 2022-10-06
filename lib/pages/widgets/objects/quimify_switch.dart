import 'package:cliente/pages/widgets/appearance/quimify_teal.dart';
import 'package:flutter/material.dart';

class QuimifySwitch extends StatelessWidget {
  const QuimifySwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: Colors.white.withOpacity(0.9),
      inactiveThumbColor: Colors.white.withOpacity(0.9),
      activeTrackColor: quimifyTeal,
      inactiveTrackColor: Theme.of(context).colorScheme.secondary,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      value: value,
      onChanged: (newValue) => onChanged(newValue),
    );
  }
}
