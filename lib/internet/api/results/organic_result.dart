import 'dart:convert';

import 'classification.dart';

class OrganicResult {
  final bool found;

  final Classification? classification;
  final String? suggestion;

  final String? structure;
  final String? name;

  final num? molecularMass;

  final String? url2D;
  final String? url3D;

  OrganicResult(
    this.found,
    this.classification,
    this.suggestion,
    this.structure,
    this.name,
    this.molecularMass,
    this.url2D,
    this.url3D,
  );

  factory OrganicResult.fromJson(String body) {
    var json = jsonDecode(body);
    return OrganicResult(
      json['found'],
      stringToClassification[json['classification']],
      json['suggestion'],
      json['structure'],
      json['name'],
      json['molecularMass'],
      json['url2D'],
      json['url3D'],
    );
  }

  // Used for reports
  @override
  String toString() {
    List<String?> identifiers = [
      classification.toString(),
      suggestion,
      structure,
      name,
      molecularMass.toString(),
      url2D,
      url3D,
    ];

    identifiers.removeWhere((identifier) => identifier == null);

    return identifiers.toString();
  }

  OrganicResult copyWith({
    bool? found,
    Classification? classification,
    String? suggestion,
    String? structure,
    String? name,
    num? molecularMass,
    String? url2D,
    String? url3D,
  }) {
    return OrganicResult(
      found ?? this.found,
      classification ?? this.classification,
      suggestion ?? this.suggestion,
      structure ?? this.structure,
      name ?? this.name,
      molecularMass ?? this.molecularMass,
      url2D ?? this.url2D,
      url3D ?? this.url3D,
    );
  }
}
