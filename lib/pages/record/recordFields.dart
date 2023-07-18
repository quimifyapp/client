import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:quimify_client/pages/calculator/molecular_mass/widgets/graph_selector.dart';
import 'package:quimify_client/utils/text.dart';

import '../organic/diagram/diagram_page.dart';
import '../organic/widgets/structure_help_dialog.dart';
import '../widgets/appearance/quimify_teal.dart';
import '../widgets/objects/quimify_help_button.dart';

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
  String formulaViewer(elementToMoles) {
    String formula = '';
    // Process elementToMoles
    int totalMoles = elementToMoles.values.reduce((sum, i) => sum + i);
    elementToMoles.forEach((symbol, moles) {
      formula += moles > 1 ? '$symbol$moles' : symbol;
    });

    return formula;
  }

  Widget _buildRecordFields(Map<String, String> record) {
    return Container(
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
            toSubscripts(formatOrganicName(record['name'] ??
                formulaViewer(jsonDecode(record['elementToMoles']!)))),
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
            if (entry.key == 'elementToMoles' || entry.key == 'elementToMass') {
              Map<String, num> elementToGrams =
                  Map<String, num>.from(jsonDecode(record['elementToGrams']!))
                      .cast<String, num>();
              Map<String, int> elementToMoles =
                  Map<String, int>.from(jsonDecode(record['elementToMoles']!))
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
    );
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
        label == 'fecha' ||
        label == 'elementToGrams' ||
        label == 'elementToMoles') {
      if (label == 'url2D') {
        if (imageProvider != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Estructura',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: HelpButton(
                            dialog: StructureHelpDialog(),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return DiagramPage(
                                  imageProvider: imageProvider!,
                                );
                              },
                            ),
                          ),
                          icon: Icon(
                            size: 30,
                            color: Theme.of(context).colorScheme.primary,
                            Icons.fullscreen_rounded,
                          ),
                        ),
                        const SizedBox(width: 5), // So it feels symmetrical
                      ],
                    ),
                  ),
                  // Picture:
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      // Diagram background:
                      color: Theme.of(context).colorScheme.surfaceTint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // To avoid rounded corners overflow:
                    clipBehavior: Clip.hardEdge,
                    child: ColorFiltered(
                      colorFilter: MediaQuery.of(context).platformBrightness ==
                              Brightness.light
                          ? const ColorFilter.matrix(
                              [
                                255 / 245, 0, 0, 0, 0, //
                                0, 255 / 245, 0, 0, 0, //
                                0, 0, 255 / 245, 0, 0, //
                                0, 0, 0, 1, 0, //
                              ],
                            )
                          : const ColorFilter.matrix(
                              [
                                -1, 0, 0, 0, 255, //
                                0, -1, 0, 0, 255, //
                                0, 0, -1, 0, 255, //
                                0, 0, 0, 1, 0, //
                              ],
                            ),
                      child: PhotoView(
                        backgroundDecoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        initialScale: 1.0,
                        gaplessPlayback: true,
                        disableGestures: true,
                        imageProvider: imageProvider!,
                        loadingBuilder: (context, event) => const Padding(
                          padding: EdgeInsets.all(60),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                              color: Colors.black, // Filter will turn it light
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ].reversed.toList(),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      } else {
        return const SizedBox();
      }
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
