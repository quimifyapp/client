import 'dart:convert';

class MolecularMassResult {
  final bool present;
  final String? formula;
  final num? molecularMass;
  final Map<String, num>? elementToGrams;
  final Map<String, int>? elementToMoles;
  final String? error;

  MolecularMassResult(
    this.present,
    this.formula,
    this.molecularMass,
    this.elementToGrams,
    this.elementToMoles,
    this.error,
  );

  factory MolecularMassResult.fromJson(String body, String formula) {
    var json = jsonDecode(body);
    return MolecularMassResult(
      json['present'],
      formula, // TODO get it from API + make it non-nullable
      json['molecularMass'],
      json['elementToGrams']?.cast<String, num>(),
      json['elementToMoles']?.cast<String, int>(),
      json['error'],
    );
  }
}
