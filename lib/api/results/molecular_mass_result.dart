import 'dart:convert';

class MolecularMassResult {
  final bool present;
  final num mass;
  final Map<String, num> elementToGrams;
  final Map<String, int> elementToMoles;
  final String error;

  MolecularMassResult(
    this.present,
    this.mass,
    this.elementToGrams,
    this.elementToMoles,
    this.error,
  );

  factory MolecularMassResult.fromJson(String body) {
    dynamic json = jsonDecode(body);

    return MolecularMassResult(
      json['encontrado'] as bool,
      (json['masa'] ?? 0.0) as double,
      (json['elemento_a_gramos'] ?? {}).cast<String, num>(),
      (json['elemento_a_moles'] ?? {}).cast<String, int>(),
      json['error'] != null ? json['error'] as String : '',
    );
  }
}
