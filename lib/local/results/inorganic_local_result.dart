import 'dart:convert';

import 'package:quimify_client/internet/api/results/inorganic_result.dart';

class InorganicLocalResult {
  final String formattedQuery;
  final String formula;
  final String? stockName, systematicName, traditionalName, commonName;
  final String? molecularMass, density, meltingPoint, boilingPoint;

  InorganicLocalResult(
    this.formattedQuery,
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

  factory InorganicLocalResult.fromResult(
          InorganicResult result, String formattedQuery) =>
      InorganicLocalResult(
        formattedQuery,
        result.formula!,
        result.stockName,
        result.systematicName,
        result.traditionalName,
        result.commonName,
        result.molecularMass,
        result.density,
        result.meltingPoint,
        result.boilingPoint,
      );

  factory InorganicLocalResult.fromJson(String body) {
    var json = jsonDecode(body);
    return InorganicLocalResult(
      json['formattedQuery'],
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

  String toJson() => jsonEncode({
        'formattedQuery': formattedQuery,
        'formula': formula,
        'stockName': stockName,
        'systematicName': systematicName,
        'traditionalName': traditionalName,
        'commonName': commonName,
        'molecularMass': molecularMass,
        'density': density,
        'meltingPoint': meltingPoint,
        'boilingPoint': boilingPoint,
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InorganicLocalResult &&
          formattedQuery == other.formattedQuery &&
          formula == other.formula &&
          stockName == other.stockName &&
          systematicName == other.systematicName &&
          traditionalName == other.traditionalName &&
          commonName == other.commonName &&
          molecularMass == other.molecularMass &&
          density == other.density &&
          meltingPoint == other.meltingPoint &&
          boilingPoint == other.boilingPoint;

  @override
  int get hashCode =>
      formattedQuery.hashCode ^
      formula.hashCode ^
      stockName.hashCode ^
      systematicName.hashCode ^
      traditionalName.hashCode ^
      commonName.hashCode ^
      molecularMass.hashCode ^
      density.hashCode ^
      meltingPoint.hashCode ^
      boilingPoint.hashCode;
}
