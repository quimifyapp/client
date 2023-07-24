import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/api/results/molecular_mass_result.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/molecular_mass_page.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/widgets/graph_selector.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_report_dialog.dart';
import 'package:quimify_client/utils/text.dart';

import '../../api/results/organic_result.dart';
import '../organic/naming/organic_result_page.dart';
import '../organic/widgets/organic_result_view.dart';
import '../widgets/appearance/quimify_teal.dart';

// TODO overflow de Matthew

class RecordFields extends StatelessWidget {
  const RecordFields({
    Key? key,
    required this.records,
    required this.context,
  }) : super(key: key);

  final List<Map<String, String>> records;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildRecordFieldsList(),
    );
  }

  List<Widget> _buildRecordFieldsList() {
    final List<Widget> recordFieldsList = [];
    for (final record in records) {
      recordFieldsList.add(
        Column(
          children: [
            _buildRecordFields(record),
            const SizedBox(height: 15),
          ],
        ),
      );
    }
    return recordFieldsList;
  }

  Widget _buildRecordFields(Map<String, String> record) {
    return GestureDetector(
        onTap: () async {
          if (record['structure'] != null) {
            //TODO method
            Navigator.of(context).pop();
          } else if (record['formula'] != null) {}
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
            color: Theme.of(context).colorScheme.surface,
          ),
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 20 - 15, // Without OrganicResultField's bottom padding
            left: 20,
            right: 20,
          ),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                toSubscripts(
                    formatOrganicName(record['name'] ?? record['formula']!)),
                minFontSize: 10,
                overflowReplacement: const Text(
                  'Proporciones',
                  maxLines: 1,
                  style: TextStyle(
                    color: quimifyTeal,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                stepGranularity: 0.1,
                maxLines: 1,
                style: const TextStyle(
                  color: quimifyTeal,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...record.entries.map((entry) {
                if (entry.key == 'elementToMoles' ||
                    entry.key == 'elementToMass') {
                  Map<String, num> elementToGrams = Map<String, num>.from(
                          jsonDecode(record['elementToGrams']!))
                      .cast<String, num>();
                  Map<String, int> elementToMoles = Map<String, int>.from(
                          jsonDecode(record['elementToMoles']!))
                      .cast<String, int>();

                  return GraphSelector(
                    mass: double.parse(record['molecularMass']!),
                    elementToGrams: elementToGrams,
                    elementToMoles: elementToMoles,
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RecordResultName(
                        label: entry.key,
                        name: entry.value,
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }
              }),
            ],
          ),
        ));
  }
}

class RecordField extends StatelessWidget {
  const RecordField({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class RecordResultName extends StatelessWidget {
  RecordResultName({
    Key? key,
    required this.label,
    // this.imageProvider,
    required this.name,
  })  : imageProvider = (label == 'url2D') ? NetworkImage(name!) : null,
        super(key: key);

  String label;
  final ImageProvider? imageProvider;
  String? name;

  @override
  Widget build(BuildContext context) {
    switch (label) {
      case 'structure':
        label = 'Estructura';
        name = formatStructure(name!);
        break;
      case 'molecularMass':
        label = 'Masa Molecular';
        name = '${formatMolecularMass(double.parse(name!))} g/mol';
        break;
      default:
        label = label;
    }
    if (label == 'name' ||
        label == 'url2D' ||
        label == 'date' ||
        label == 'elementToGrams' ||
        label == 'elementToMoles') {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (name != null) ...[
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: quimifyTeal,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.onSurface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
