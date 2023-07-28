import 'dart:convert';

import 'package:quimify_client/api/results/inorganic_result.dart';
import 'package:quimify_client/api/results/molecular_mass_result.dart';
import 'package:quimify_client/api/results/organic_result.dart';
import 'package:quimify_client/local/results/inorganic_local_result.dart';
import 'package:quimify_client/local/results/molecular_mass_local_result.dart';
import 'package:quimify_client/local/results/organic_formula_local_result.dart';
import 'package:quimify_client/local/results/organic_name_local_result.dart';
import 'package:quimify_client/local/storage.dart';

class History {
  // Constants:

  static const String _inorganicsKey = 'inorganics';
  static const String _organicFormulasKey = 'organic-formulas';
  static const String _organicNamesKey = 'organic-names';
  static const String _molecularMassesKey = 'molecular-masses';

  // Private:

  static List<dynamic> _fetch(String key, Function(String) fromJson) {
    final String? data = Storage().get(key);

    if (data == null) {
      return [];
    }

    return jsonDecode(data).map((e) => fromJson(e)).toList().toList();
  }

  static _save(String key, dynamic localResult, List<dynamic> localResults) {
    localResults.remove(localResult);
    localResults.insert(0, localResult);

    List<dynamic> newData = localResults.map((e) => e.toJson()).toList();

    Storage().save(key, jsonEncode(newData));
  }

  // Public:

  static List<InorganicLocalResult> getInorganics() =>
      _fetch(_inorganicsKey, InorganicLocalResult.fromJson)
          .cast<InorganicLocalResult>();

  static saveInorganic(InorganicResult result, String formattedQuery) => _save(
        _inorganicsKey,
        InorganicLocalResult.fromResult(result, formattedQuery),
        getInorganics(),
      );

  static List<OrganicFormulaLocalResult> getOrganicFormulas() =>
      _fetch(_organicFormulasKey, OrganicFormulaLocalResult.fromJson)
          .cast<OrganicFormulaLocalResult>();

  static saveOrganicFormula(OrganicResult result) => _save(
        _organicFormulasKey,
        OrganicFormulaLocalResult.fromResult(result),
        getOrganicFormulas(),
      );

  static List<OrganicNameLocalResult> getOrganicNames() =>
      _fetch(_organicNamesKey, OrganicNameLocalResult.fromJson)
          .cast<OrganicNameLocalResult>();

  static saveOrganicName(OrganicResult result, List<int> sequence) => _save(
        _organicNamesKey,
        OrganicNameLocalResult.fromResult(result, sequence),
        getOrganicNames(),
      );

  static List<MolecularMassLocalResult> getMolecularMasses() =>
      _fetch(_molecularMassesKey, MolecularMassLocalResult.fromJson)
          .cast<MolecularMassLocalResult>();

  static saveMolecularMass(MolecularMassResult result) => _save(
        _molecularMassesKey,
        MolecularMassLocalResult.fromResult(result),
        getMolecularMasses(),
      );
}
