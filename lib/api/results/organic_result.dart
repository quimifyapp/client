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
    var json = jsonDecode(body);
    return OrganicResult(
      json['present'],
      json['structure'],
      json['name'],
      json['molecularMass'],
      json['url2D'],
    );
  }

  // Used for reports
  @override
  String toString() {
    List<String?> identifiers = [
      structure,
      name,
      url2D,
      molecularMass.toString(),
    ];

    identifiers.removeWhere((identifier) => identifier == null);

    return identifiers.toString();
  }
}
