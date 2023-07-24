import 'dart:convert';

import 'package:quimify_client/api/results/molecular_mass_result.dart';
import 'package:quimify_client/api/results/organic_result.dart';
import 'package:quimify_client/local/cache.dart';

class History {
  // Constants:

  static const String _organicFormulasKey = 'organic-formulas';
  static const String _molecularMassesKey = 'molecular-masses';

  static Future<List<Map<String, String>>> getOrganicFormulas() async {
    // TODO return type?
    final String? organicFormulas = Cache().get(_organicFormulasKey);

    if (organicFormulas == null) {
      return [];
    }

    final List<dynamic> organicFormulasJson = jsonDecode(organicFormulas);

    return organicFormulasJson
        .map((json) => Map<String, String>.from(json))
        .toList();
  }

  static Future<List<Map<String, String>>> getMolecularMasses() async {
    final String? molecularMassesString = Cache().get(_molecularMassesKey);

    if (molecularMassesString == null) {
      return [];
    }

    final List<dynamic> molecularMassesJson = jsonDecode(molecularMassesString);

    return molecularMassesJson
        .map((json) => Map<String, String>.from(json))
        .toList();
  }

  static Future<void> saveOrganic(OrganicResult result) async {
    // TODO separar en los 2 menús de orgánica
    String structure = result.structure!;

    dynamic organicResults = await getOrganicFormulas();

    organicResults
        .removeWhere((existing) => existing['structure'] == structure);

    organicResults.insert(0, {
      'date': DateTime.now().toString(),
      'name': result.name!,
      'structure': structure,
    });

    await Cache().save(_organicFormulasKey, jsonEncode(organicResults));
  }

  static Future<void> saveMolecularMass(MolecularMassResult result) async {
    String formula = result.formula;
    String molecularMass = result.molecularMass!.toString(); //tested

    dynamic molecularMassResults = await getMolecularMasses(); // TODO rename

    molecularMassResults.removeWhere((existing) =>
        existing['formula'] == formula &&
        existing['molecularMass'] == molecularMass);

    molecularMassResults.insert(0, {
      'date': DateTime.now().toString(),
      'formula': formula,
      'molecularMass': molecularMass,
    });

    await Cache().save(_molecularMassesKey, jsonEncode(molecularMassResults));
  }
}
