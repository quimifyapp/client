import 'package:auto_size_text/auto_size_text.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_loading.dart';
import 'package:flutter/material.dart';

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
          top: 15,
          bottom: 20,
          left: 20,
          right: 20,
        ),
        child: Row(
          children: [
            QuimifyIconButton.square(
              height: 50,
              backgroundColor:
                  Theme.of(context).colorScheme.onTertiaryContainer,
              onPressed: () {
                Navigator.of(context).pop();
                stopqQuimifyLoading();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: AutoSizeText(
                title,
                maxLines: 1,
                stepGranularity: 0.1,
                maxFontSize: 20,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onPrimary,
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
