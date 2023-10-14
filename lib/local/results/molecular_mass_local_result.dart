import 'dart:convert';

import 'package:quimify_client/internet/api/results/molecular_mass_result.dart';

class MolecularMassLocalResult {
  late final String formula;
  late final num molecularMass;

  MolecularMassLocalResult(
    this.formula,
    this.molecularMass,
  );

  factory MolecularMassLocalResult.fromResult(MolecularMassResult result) =>
      MolecularMassLocalResult(
        result.formula!,
        result.molecularMass!,
      );

  factory MolecularMassLocalResult.fromJson(String body) {
    var json = jsonDecode(body);
    return MolecularMassLocalResult(
      json['formula'],
      json['molecularMass'],
    );
  }

  String toJson() => jsonEncode({
        'formula': formula,
        'molecularMass': molecularMass,
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MolecularMassLocalResult &&
          formula == other.formula &&
          molecularMass == other.molecularMass;

  @override
  int get hashCode => formula.hashCode ^ molecularMass.hashCode;
}
