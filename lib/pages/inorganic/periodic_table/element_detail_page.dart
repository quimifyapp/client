import 'package:flutter/material.dart';
import 'package:quimify_client/pages/inorganic/periodic_table/periodic_element.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
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
      header: const QuimifyPageBar(title: 'Volver'),
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
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.width * 0.45,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0A2421),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientText(
                element.atomicNumber.toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
                colors: const [
                  Color.fromARGB(255, 55, 224, 211),
                  Color.fromARGB(255, 72, 232, 167),
                ],
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
                      element.name,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      colors: const [
                        Color.fromARGB(255, 55, 224, 211),
                        Color.fromARGB(255, 72, 232, 167),
                      ],
                    ),
                    GradientText(
                      element.atomicWeight.toStringAsFixed(4),
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
        const Text(
          'Información general',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _InfoRow(
                leftLabel: 'Punto de fusión',
                leftValue: '${element.meltingPoint}°C',
                rightLabel: 'P. de ebullición',
                rightValue: '${element.boilingPoint}°C',
              ),
              const SizedBox(height: 24),
              _InfoRow(
                leftLabel: 'Número atómico',
                leftValue: element.atomicNumber.toString(),
                rightLabel: 'Peso atómico',
                rightValue: element.atomicWeight.toStringAsFixed(4),
              ),
              const SizedBox(height: 24),
              _SingleInfo(
                label: 'Estado a temperatura ambiente (20°C)',
                value: element.phase,
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
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w500,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acerca del ${element.name.toLowerCase()}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            element.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
