import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

enum QuimifyMascotTone {
  positive,
  negative,
}

class QuimifyMascotMessage extends StatelessWidget {
  QuimifyMascotMessage({
    super.key,
    required this.tone,
    required this.title,
    required this.details,
    required this.buttonLabel,
    required this.onButtonPressed,
  }) : _hasButton = true;

  QuimifyMascotMessage.withoutButton({
    super.key,
    required this.tone,
    required this.title,
    required this.details,
  })  : _hasButton = false,
        buttonLabel = null,
        onButtonPressed = null;

  final QuimifyMascotTone tone;
  final String title;
  final String details;

  final bool _hasButton;

  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  final Map<QuimifyMascotTone, String> _toneToImagePath = {
    QuimifyMascotTone.positive: 'assets/images/completed.png',
    QuimifyMascotTone.negative: 'assets/images/empty.png',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: QuimifyColors.foreground(context),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            _toneToImagePath[tone]!,
            height: 150,
          ),
          const SizedBox(height: 20),
          AutoSizeText(
            title,
            maxLines: 1,
            stepGranularity: 0.1,
            maxFontSize: 20,
            style: TextStyle(
              fontSize: 20,
              color: QuimifyColors.primary(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            details,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: QuimifyColors.primary(context),
              fontSize: 16,
            ),
            strutStyle: const StrutStyle(height: 1.5),
          ),
          if (_hasButton) ...[
            const SizedBox(height: 20),
            QuimifyButton.gradient(
              height: 50,
              onPressed: onButtonPressed!,
              child: Text(
                buttonLabel!,
                style: TextStyle(
                  color: QuimifyColors.inverseText(context),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          if (!_hasButton) const SizedBox(height: 5),
        ],
      ),
    );
  }
}
