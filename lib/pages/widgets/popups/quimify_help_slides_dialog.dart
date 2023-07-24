import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/gestures/quimify_swipe_detector.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_contact_buttons.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_button.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_content_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class QuimifyHelpSlidesDialog extends StatefulWidget {
  const QuimifyHelpSlidesDialog({
    Key? key,
    required this.titleToContent,
  }) : super(key: key);

  final Map<String, List<Widget>> titleToContent;

  @override
  State<QuimifyHelpSlidesDialog> createState() =>
      _QuimifyHelpSlidesDialogState();
}

class _QuimifyHelpSlidesDialogState extends State<QuimifyHelpSlidesDialog> {
  late Map<String, List<Widget>> titleToContent = {...widget.titleToContent};
  late int _currentSlide = 0;

  _exit(BuildContext context) => Navigator.of(context).pop();

  _goToSlide(int slide) => setState(() => _currentSlide = slide);

  _goToNextSlide() => _currentSlide < titleToContent.length - 1
      ? _goToSlide(_currentSlide + 1)
      : _exit(context);

  _goToPreviousSlide() =>
      _currentSlide > 0 ? _goToSlide(_currentSlide - 1) : _exit(context);

  @override
  Widget build(BuildContext context) {
    titleToContent['¿Necesitas ayuda?'] = [
      const Center(
        child: QuimifyDialogContentText(
          text: 'Chatea con nosotros y solucionaremos tus dudas al momento.',
        ),
      ),
      QuimifyContactButtons(
        afterClicked: () => _exit(context),
      ),
    ];

    return QuimifySwipeDetector(
      leftSwipe: _goToPreviousSlide,
      rightSwipe: _goToNextSlide, // Swipe right
      child: QuimifyDialog(
        title: titleToContent.keys.elementAt(_currentSlide),
        content: titleToContent.values.elementAt(_currentSlide),
        actions: [
          Center(
            child: AnimatedSmoothIndicator(
              activeIndex: _currentSlide,
              count: titleToContent.length,
              duration: const Duration(milliseconds: 0),
              effect: ColorTransitionEffect(
                dotWidth: 10,
                dotHeight: 10,
                activeDotColor: quimifyTeal,
                dotColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          QuimifyDialogButton(
            onPressed: _goToNextSlide,
            text: _currentSlide < titleToContent.length - 1
                ? 'Siguiente'
                : 'Entendido',
          ),
        ],
      ),
    );
  }
}
