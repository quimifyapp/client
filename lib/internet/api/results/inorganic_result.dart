import 'dart:convert';

import 'package:quimify_client/storage/history/results/inorganic_local_result.dart';

class InorganicResult {
  final bool found;
  final String? suggestion;

  final String? formula;
  final String? stockName, systematicName, traditionalName, commonName;

  final String? molecularMass, density, meltingPoint, boilingPoint;

  InorganicResult(
    this.found,
    this.suggestion,

    this.formula,
    this.stockName,
    this.systematicName,
    this.traditionalName,
    this.commonName,

    this.molecularMass,
    this.density,
    this.meltingPoint,
    this.boilingPoint,
  );

  factory InorganicResult.fromJson(String body) {
    var json = jsonDecode(body);
    return InorganicResult(
      json['found'],
      json['suggestion'],

      json['formula'],
      json['stockName'],
      json['systematicName'],
      json['traditionalName'],
      json['commonName'],

      json['molecularMass'],
      json['density'],
      json['meltingPoint'],
      json['boilingPoint'],
    );
  }

  factory InorganicResult.fromLocal(InorganicLocalResult localResult) =>
      InorganicResult(
        true,
        null,

        localResult.formula,
        localResult.stockName,
        localResult.systematicName,
        localResult.traditionalName,
        localResult.commonName,

        localResult.molecularMass,
        localResult.density,
        localResult.meltingPoint,
        localResult.boilingPoint,
      );

  // Used for reports
  @override
  String toString() {
    List<String?> identifiers = [
      formula,
      stockName,
      systematicName,
      traditionalName,
      commonName,

      molecularMass,
      density,
      meltingPoint,
      boilingPoint,
    ];

    identifiers.removeWhere((identifier) => identifier == null);

    return identifiers.toString();
  }
}
