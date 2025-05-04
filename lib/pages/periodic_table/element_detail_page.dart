import 'package:flutter/material.dart';
import 'package:quimify_client/pages/periodic_table/periodic_element.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/utils/localisation_extension.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ElementDetailPage extends StatelessWidget {
  final PeriodicElement element;

  const ElementDetailPage({
    Key? key,
    required this.element,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold.noAd(
      header: QuimifyPageBar(title: context.l10n.back),
      body: _Body(element: element),
    );
  }
}

class _Body extends StatelessWidget {
  final PeriodicElement element;

  const _Body({
    Key? key,
    required this.element,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _ElementCard(element: element),
          const SizedBox(height: 24),
          _GeneralInfo(element: element),
          const SizedBox(height: 24),
          _AboutElement(element: element),
        ],
      ),
    );
  }
}

class _ElementCard extends StatelessWidget {
  final PeriodicElement element;

  const _ElementCard({
    Key? key,
    required this.element,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentLanguage = Localizations.localeOf(context).languageCode;
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.48,
          height: MediaQuery.of(context).size.width * 0.48,
          decoration: BoxDecoration(
            color: QuimifyColors.foreground(context),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: GradientText(
                  element.atomicNumber.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  colors: const [
                    Color.fromARGB(255, 55, 224, 211),
                    Color.fromARGB(255, 72, 232, 167),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    GradientText(
                      element.symbol,
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                      ),
                      colors: const [
                        Color.fromARGB(255, 55, 224, 211),
                        Color.fromARGB(255, 72, 232, 167),
                      ],
                    ),
                    GradientText(
                      currentLanguage == 'es' ? element.name : element.nameEn,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      colors: const [
                        Color.fromARGB(255, 55, 224, 211),
                        Color.fromARGB(255, 72, 232, 167),
                      ],
                    ),
                    GradientText(
                      element.atomicWeight.toStringAsFixed(3),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      colors: const [
                        Color.fromARGB(255, 55, 224, 211),
                        Color.fromARGB(255, 72, 232, 167),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'https://images-of-elements.com/${element.nameEn}.jpg',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(); // Return empty container if image not found
            },
          ),
        ),
      ],
    );
  }
}

class _GeneralInfo extends StatelessWidget {
  final PeriodicElement element;

  const _GeneralInfo({
    Key? key,
    required this.element,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.generalInfo,
          style: TextStyle(
            color: QuimifyColors.teal(),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: QuimifyColors.foreground(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _InfoRow(
                leftLabel: context.l10n.meltingPoint,
                leftValue: '${element.meltingPoint}°C',
                rightLabel: context.l10n.boilingPoint,
                rightValue: '${element.boilingPoint}°C',
              ),
              const SizedBox(height: 24),
              _InfoRow(
                leftLabel: context.l10n.atomicNumber,
                leftValue: element.atomicNumber.toString(),
                rightLabel: context.l10n.atomicWeight,
                rightValue: element.atomicWeight.toStringAsFixed(3),
              ),
              const SizedBox(height: 24),
              _SingleInfo(
                label: context.l10n.stateAtRoomTemperature,
                value: element.phase,
              ),
              const SizedBox(height: 24),
              _SingleInfo(
                label: context.l10n.electronConfiguration,
                value:
                    '${element.electronConfiguration}\n\n${element.simplifiedElectronConfiguration}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  const _InfoRow({
    Key? key,
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SingleInfo(
            label: leftLabel,
            value: leftValue,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _SingleInfo(
            label: rightLabel,
            value: rightValue,
          ),
        ),
      ],
    );
  }
}

class _SingleInfo extends StatelessWidget {
  final String label;
  final String value;

  const _SingleInfo({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: QuimifyColors.teal(),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: QuimifyColors.primary(context),
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutElement extends StatelessWidget {
  final PeriodicElement element;

  const _AboutElement({
    Key? key,
    required this.element,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentLanguage = Localizations.localeOf(context).languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.l10n.about} ${currentLanguage == 'es' ? element.name : element.nameEn.toLowerCase()}',
          style: TextStyle(
            color: QuimifyColors.teal(),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: QuimifyColors.foreground(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            currentLanguage == 'es'
                ? element.description
                : element.descriptionEn,
            style: TextStyle(
              color: QuimifyColors.primary(context),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
