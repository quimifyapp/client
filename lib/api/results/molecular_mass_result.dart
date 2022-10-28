import 'dart:convert';

class MolecularMassResult {
  final bool present;
  final num? molecularMass;
  final Map<String, num> elementToGrams;
  final Map<String, int> elementToMoles;
  final String? error;

  MolecularMassResult(
    this.present,
    this.molecularMass,
    this.elementToGrams,
    this.elementToMoles,
    this.error,
  );

  factory MolecularMassResult.fromJson(String body) {
    dynamic json = jsonDecode(body);
    return MolecularMassResult(
      json['present'] as bool,
      json['molecularMass'] as num?,
      (json['elementToGrams'] ?? {}).cast<String, num>(),
      (json['elementToMoles'] ?? {}).cast<String, int>(),
      json['error'] as String?,
    );
  }
}
