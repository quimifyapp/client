import 'dart:convert';

import 'package:quimify_client/api/results/molecular_mass_result.dart';
import 'package:quimify_client/api/results/organic_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static final CacheManager _singleton = CacheManager._internal();

  factory CacheManager() => _singleton;

  CacheManager._internal();

  // Constants:

  static const String keyOrganicFormulas = 'organic_formulas';
  static const String keyMolecularMasses = 'molecular_masses';
  static const String keyCompoundNames = 'compound_names'; // TODO ??

  Future<List<Map<String, String>>> getOrganicFormulas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? organicFormulasString = prefs.getString(keyOrganicFormulas);
    if (organicFormulasString != null) {
      final List<dynamic> organicFormulasJson =
          jsonDecode(organicFormulasString);
      return organicFormulasJson
          .map((json) => Map<String, String>.from(json))
          .toList();
    }
    return [];
  }

  Future<List<Map<String, String>>> getMolecularMasses() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? molecularMassesString = prefs.getString(keyMolecularMasses);
    if (molecularMassesString != null) {
      final List<dynamic> molecularMassesJson =
          jsonDecode(molecularMassesString);
      return molecularMassesJson
          .map((json) => Map<String, String>.from(json))
          .toList();
    }
    return [];
  }

  Future<List<Map<String, String>>> getAllHistory() async {
    final List<Map<String, String>> allHistory = [];

    final List<Map<String, String>> organicFormulas =
        await getOrganicFormulas();
    final List<Map<String, String>> molecularMasses =
        await getMolecularMasses();

    allHistory.addAll(organicFormulas);
    allHistory.addAll(molecularMasses);

    allHistory.sort((a, b) {
      final DateTime dateA = DateTime.parse(a['fecha']!);
      final DateTime dateB = DateTime.parse(b['fecha']!);
      return dateB.compareTo(dateA);
    });

    return allHistory;
  }

  Future<void> saveOrganicResult(OrganicResult result) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, String>> currentOrganicFormulas =
        await getOrganicFormulas();

    final Map<String, String> resultData = {
      // 'present': result.present.toString(),
      'structure': result.structure ?? '',
      'name': result.name ?? '',
      'molecularMass': result.molecularMass?.toString() ?? '',
      'url2D': result.url2D ?? '',
      'fecha': DateTime.now().toString(),
    };

    final String newItemFormula = resultData['name']!;
    currentOrganicFormulas
        .removeWhere((existingItem) => existingItem['name'] == newItemFormula);
    currentOrganicFormulas.insert(0, resultData);

    final String organicFormulasString = jsonEncode(currentOrganicFormulas);
    await prefs.setString(keyOrganicFormulas, organicFormulasString);
  }

  Future<void> saveMolecularMassResult(MolecularMassResult result) async {
    print(result);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, String>> currentMolecularMasses =
        await getMolecularMasses();

    final Map<String, String> resultData = {
      'molecularMass': result.molecularMass?.toString() ?? '',
      'elementToGrams': jsonEncode(result.elementToGrams),
      'elementToMoles': jsonEncode(result.elementToMoles),
      'fecha': DateTime.now().toString(),
    };

    final String newItemCompound = resultData['elementToMoles']!;
    currentMolecularMasses.removeWhere(
        (existingItem) => existingItem['elementToMoles'] == newItemCompound);
    currentMolecularMasses.insert(0, resultData);

    final String molecularMassesString = jsonEncode(currentMolecularMasses);
    await prefs.setString(keyMolecularMasses, molecularMassesString);
  }

  Future<void> clearHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('history');
  }
}
