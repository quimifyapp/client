import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/widgets/quimify_dialog_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class QuimifySlidesDialog extends StatefulWidget {
  const QuimifySlidesDialog({
    Key? key,
    required this.titleToContent,
  }) : super(key: key);

  final Map<String, List<Widget>> titleToContent;

  @override
  State<QuimifySlidesDialog> createState() => _QuimifySlidesDialogState();
}

class _QuimifySlidesDialogState extends State<QuimifySlidesDialog> {
  late int _currentSlide = 0;

  void _goToSlide(int slide) => setState(() => _currentSlide = slide);

  void _goToNextSlide() {
    if (_currentSlide < widget.titleToContent.length - 1) {
      _goToSlide(_currentSlide + 1);
    } else {
      Navigator.pop(context);
    }
  }

  void _goToPreviousSlide() {
    if (_currentSlide > 0) {
      _goToSlide(_currentSlide - 1);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails dragEndDetails) =>
      (dragEndDetails.primaryVelocity ?? 0) > 0
              ? _goToPreviousSlide() // Swipe left
              : _goToNextSlide(), // Swipe right
      child: QuimifyDialog(
        title: widget.titleToContent.keys.elementAt(_currentSlide),
        content: widget.titleToContent.values.elementAt(_currentSlide),
        actions: [
          Center(
            child: AnimatedSmoothIndicator(
              activeIndex: _currentSlide,
              count: widget.titleToContent.length,
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
            text: _currentSlide < widget.titleToContent.length - 1
                ? 'Siguiente'
                : 'Entendido',
          ),
        ],
      ),
    );
  }
}
