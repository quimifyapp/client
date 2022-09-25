import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../widgets/help_button.dart';
import '../../../../widgets/result_button.dart';

class ResultDisplay extends StatelessWidget {
  const ResultDisplay({
    Key? key,
    required this.firstTitle,
    required this.firstField,
    required this.secondTitle,
    required this.secondField,
    this.thirdTitle,
    this.thirdField,
    required this.imageProvider,
  }) : super(key: key);

  final String firstTitle, firstField, secondTitle, secondField;
  final String? thirdTitle, thirdField;

  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      // To avoid rounded corners overflow:
      clipBehavior: Clip.hardEdge,
      child: Container(
        padding: const EdgeInsets.only(
          top: 30,
          bottom: 5,
          left: 25,
          right: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Resultado',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                ResultButton(
                  size: 44,
                  color: Theme.of(context).colorScheme.onError,
                  backgroundColor: Theme.of(context).colorScheme.error,
                  icon: Image.asset(
                    'assets/images/icons/report.png',
                    color: Theme.of(context).colorScheme.onError,
                    width: 18,
                  ),
                ),
                const SizedBox(width: 12),
                ResultButton(
                  size: 44,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  icon: Icon(
                    Icons.share_outlined,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Container(
              height: 1.5,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ResultField(title: firstTitle, field: firstField),
                  const SizedBox(height: 15),
                  ResultField(title: secondTitle, field: secondField),
                  if (thirdField != null) ...[
                    const SizedBox(height: 15),
                    ResultField(
                      title: thirdTitle!,
                      field: thirdField!,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Text(
                  'Estructura:',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const Spacer(),
                const HelpButton(),
              ],
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                // To avoid rounded corners overflow:
                clipBehavior: Clip.hardEdge,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? [
                            -1, 0, 0, 0, 255, //
                            0, -1, 0, 0, 255, //
                            0, 0, -1, 0, 255, //
                            0, 0, 0, 1, 0, //
                          ]
                        : [
                            1, 0, 0, 0, 0, //
                            0, 1, 0, 0, 0, //
                            0, 0, 1, 0, 0, //
                            0, 0, 0, 1, 0, //
                          ],
                  ),
                  child: PhotoView(
                    filterQuality: FilterQuality.high,
                    gaplessPlayback: true,
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    minScale: 0.5,
                    maxScale: 5.0,
                    imageProvider: imageProvider,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class ResultField extends StatelessWidget {
  const ResultField({Key? key, required this.title, required this.field})
      : super(key: key);

  final String title, field;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AutoSizeText(
            field,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
