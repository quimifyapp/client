import 'dart:convert';

class InorganicResult {
  final bool present;
  final String? formula, name;
  final String? alternativeName;
  final num? molecularMass;
  final String? density, meltingPoint, boilingPoint;

  InorganicResult(
    this.present,
    this.formula,
    this.name,
    this.alternativeName,
    this.molecularMass,
    this.density,
    this.meltingPoint,
    this.boilingPoint,
  );

  factory InorganicResult.fromJson(String body) {
    dynamic json = jsonDecode(body);
    return InorganicResult(
      json['present'] as bool,
      json['formula'] as String?,
      json['name'] as String?,
      json['alternativeName'] as String?,
      json['molecularMass'] as num?,
      json['density'] as String?,
      json['meltingPoint'] as String?,
      json['boilingPoint'] as String?,
    );
  }
}
