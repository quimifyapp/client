import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class QuimifyPageBar extends StatelessWidget {
  const QuimifyPageBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.only(
          top: 15, // TODO 17.5? Any way to make it symmetrical in all devices?
          bottom: 20,
          left: 20,
          right: 20,
        ),
        child: Row(
          children: [
            QuimifyIconButton.square(
              height: 50,
              backgroundColor: QuimifyColors.secondaryTeal(context),
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back,
                color: QuimifyColors.inverseText(context),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: AutoSizeText(
                title,
                maxLines: 1,
                stepGranularity: 0.1,
                maxFontSize: 20,
                style: TextStyle(
                  fontSize: 20,
                  color: QuimifyColors.inverseText(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
