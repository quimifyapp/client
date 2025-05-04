import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/contact_buttons.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_button.dart';
import 'package:quimify_client/pages/widgets/dialogs/widgets/dialog_content_text.dart';
import 'package:quimify_client/pages/widgets/gestures/quimify_swipe_detector.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/utils/localisation_extension.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HelpSlidesDialog extends StatefulWidget {
  const HelpSlidesDialog({
    Key? key,
    required this.titleToContent,
  }) : super(key: key);

  final Map<String, List<Widget>> titleToContent;

  @override
  State<HelpSlidesDialog> createState() => _HelpSlidesDialogState();
}

class _HelpSlidesDialogState extends State<HelpSlidesDialog> {
  late final Map<String, List<Widget>> _titleToContent = {
    ...widget.titleToContent
  };
  late int _currentSlide = 0;

  _exit(BuildContext context) => Navigator.of(context).pop();

  _goToSlide(int slide) => setState(() => _currentSlide = slide);

  _goToNextSlide() => _currentSlide < _titleToContent.length - 1
      ? _goToSlide(_currentSlide + 1)
      : _exit(context);

  _goToPreviousSlide() =>
      _currentSlide > 0 ? _goToSlide(_currentSlide - 1) : _exit(context);

  @override
  Widget build(BuildContext context) {
    _titleToContent[context.l10n.doYouNeedHelp] = [
      Center(
        child: DialogContentText(
          richText: context.l10n.needHelpDescription,
        ),
      ),
      ContactButtons(
        afterClicked: () => _exit(context),
      ),
    ];

    return QuimifySwipeDetector(
      leftSwipe: _goToPreviousSlide,
      rightSwipe: _goToNextSlide, // Swipe right
      child: QuimifyDialog(
        title: _titleToContent.keys.elementAt(_currentSlide),
        content: _titleToContent.values.elementAt(_currentSlide),
        actions: [
          Center(
            child: AnimatedSmoothIndicator(
              activeIndex: _currentSlide,
              count: _titleToContent.length,
              duration: const Duration(milliseconds: 0),
              effect: ColorTransitionEffect(
                dotWidth: 10,
                dotHeight: 10,
                activeDotColor: QuimifyColors.teal(),
                dotColor: QuimifyColors.tertiary(context),
              ),
            ),
          ),
          const SizedBox(height: 20),
          DialogButton(
            onPressed: _goToNextSlide,
            text: _currentSlide < _titleToContent.length - 1
                ? context.l10n.next
                : context.l10n.understood,
          ),
        ],
      ),
    );
  }
}
