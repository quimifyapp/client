import 'dart:convert';

class InorganicResult {
  final bool present, premium;
  final String name, formula;
  final String? synonym, mass, density, meltingPoint, boilingPoint;

  final String? suggestion;
  final bool? isOrganicSuggestion;

  InorganicResult(
    this.present,
    this.premium,
    this.formula,
    this.name,
    this.synonym,
    this.mass,
    this.density,
    this.meltingPoint,
    this.boilingPoint,
    this.suggestion,
    this.isOrganicSuggestion,
  );

  factory InorganicResult.fromJson(String body) {
    dynamic json = jsonDecode(body);
    return InorganicResult(
      json['encontrado'] as bool,
      json['premium'] as bool,
      json['formula'] as String,
      json['nombre'] as String,
      json['alternativo'] as String?,
      json['masa'] as String?,
      json['densidad'] as String?,
      json['fusion'] as String?,
      json['ebullicion'] as String?,
      json['sugerencia'] as String?,
      json['es_organico_sugerencia'] as bool?,
    );
  }
}
