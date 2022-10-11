import 'dart:convert';

class OrganicResult {
  final bool present;

  final String? name, structure, url2D;
  final num? mass;

  final bool? isInorganicSuggestion;

  OrganicResult(
    this.present,
    this.structure,
    this.name,
    this.mass,
    this.url2D,
    this.isInorganicSuggestion,
  );

  factory OrganicResult.fromJson(String body) {
    dynamic json = jsonDecode(body);
    return OrganicResult(
      json['encontrado'] as bool,
      json['formula'] as String?,
      json['nombre'] as String?,
      json['masa'] as num?,
      json['url_2d'] as String?,
      json['es_inorganico_sugerencia'] as bool?,
    );
  }
}
