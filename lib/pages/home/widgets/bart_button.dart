import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_gradient.dart';

class BarButton extends StatelessWidget {
  const BarButton({
    Key? key,
    required this.title,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: selected ? quimifyGradient : null,
        ),
        child: MaterialButton(
          padding: const EdgeInsets.all(0),
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(
              color: selected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
