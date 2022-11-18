import 'dart:convert';

class InorganicResult {
  final bool present;
  final String? formula;
  final String? stockName, systematicName, traditionalName, otherName;
  final String? molecularMass, density, meltingPoint, boilingPoint;

  InorganicResult(
    this.present,
    this.formula,
    this.stockName,
    this.systematicName,
    this.traditionalName,
    this.otherName,
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
      json['stockName'] as String?,
      json['systematicName'] as String?,
      json['traditionalName'] as String?,
      json['otherName'] as String?,
      json['molecularMass'] as String?,
      json['density'] as String?,
      json['meltingPoint'] as String?,
      json['boilingPoint'] as String?,
    );
  }
}
