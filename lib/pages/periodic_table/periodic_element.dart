import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class PeriodicElement {
  final String name;
  final String nameEn;
  final String symbol;
  final String classification;
  final int tableRow;
  final String tableColumn;
  final int atomicNumber;
  final double atomicWeight;
  final double meltingPoint;
  final double boilingPoint;
  final String phase;
  final String electronConfiguration;
  final String simplifiedElectronConfiguration;
  final String description;

  PeriodicElement({
    required this.nameEn,
    required this.name,
    required this.symbol,
    required this.classification,
    required this.tableRow,
    required this.tableColumn,
    required this.atomicNumber,
    required this.atomicWeight,
    required this.meltingPoint,
    required this.boilingPoint,
    required this.phase,
    required this.electronConfiguration,
    required this.simplifiedElectronConfiguration,
    required this.description,
  });

  factory PeriodicElement.fromCsv(Map<String, dynamic> map) {
    return PeriodicElement(
      nameEn: map['element_name_en'] ?? '',
      name: map['element_name'] ?? '',
      symbol: map['symbol'] ?? '',
      classification: map['classification'] ?? '',
      tableRow: int.tryParse(map['table_row']?.toString() ?? '') ?? 0,
      tableColumn: map['table_column'] ?? '',
      atomicNumber: int.tryParse(map['atomic_number']?.toString() ?? '') ?? 0,
      atomicWeight:
          double.tryParse(map['atomic_weight']?.toString() ?? '') ?? 0.0,
      meltingPoint:
          double.tryParse(map['melting_point']?.toString() ?? '') ?? double.nan,
      boilingPoint:
          double.tryParse(map['boiling_point']?.toString() ?? '') ?? double.nan,
      phase: map['phase'] ?? '',
      electronConfiguration: map['electron_configuration'] ?? '',
      simplifiedElectronConfiguration:
          map['simplified_electron_configuration'] ?? '',
      description: map['description'] ?? '',
    );
  }

  // Helper method to get column index from table_column (A, B, C, etc.)
  int get columnIndex {
    // Convert column letter to index (A=0, B=1, etc.)
    if (tableColumn.isEmpty) return 0;
    return tableColumn.codeUnitAt(0) - 'A'.codeUnitAt(0);
  }

  // Helper method to get color based on classification
  Color getForegroundColor() {
    final categoryColors = {
      'Non metal': QuimifyColors.reactiveNonMetal(),
      'Transition metals': QuimifyColors.transitionMetal(),
      'Halogens': QuimifyColors.halogene(),
      'Other metals': QuimifyColors.postTransitionMetal(),
      'Noble gases': QuimifyColors.nobleGas(),
      'Alkali metals': QuimifyColors.alkaliMetal(),
      'Metalloids': QuimifyColors.metalloid(),
      'Actinides': QuimifyColors.actinide(),
      'Alkaline earth metals': QuimifyColors.alkalineEarthMetal(),
      'Lanthanides': QuimifyColors.lanthanide(),
    };

    return categoryColors[classification] ?? QuimifyColors.teal();
  }

  // Helper method to get color based on classification
  Color getBackgroundColor() {
    final categoryColors = {
      'Non metal': QuimifyColors.reactiveNonMetalLight(),
      'Transition metals': QuimifyColors.transitionMetalLight(),
      'Halogens': QuimifyColors.halogeneLight(),
      'Other metals': QuimifyColors.postTransitionMetalLight(),
      'Noble gases': QuimifyColors.nobleGasLight(),
      'Alkali metals': QuimifyColors.alkaliMetalLight(),
      'Metalloids': QuimifyColors.metalloidLight(),
      'Actinides': QuimifyColors.actinideLight(),
      'Alkaline earth metals': QuimifyColors.alkalineEarthMetalLight(),
      'Lanthanides': QuimifyColors.lanthanideLight(),
    };

    return categoryColors[classification] ?? QuimifyColors.teal();
  }
}
