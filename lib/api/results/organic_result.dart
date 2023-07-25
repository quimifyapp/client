import 'dart:convert';

class OrganicResult {
  final bool present;

  final String? structure;
  final String? name;
  final num? molecularMass;
  final String? url2D;

  OrganicResult(
    this.present,
    this.structure,
    this.name,
    this.molecularMass,
    this.url2D,
  );

  factory OrganicResult.fromJson(String body) {
    dynamic json = jsonDecode(body);
    return OrganicResult(
        json['present'] as bool,
        json['structure'] as String?,
        json['name'] as String?,
        json['molecularMass'] as num?,
        json['url2D'] as String?);
  }
}
