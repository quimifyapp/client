import 'dart:convert';

import 'package:quimify_client/api/results/organic_result.dart';

class OrganicLocalResult {
  late final String structure;
  late final String name;

  OrganicLocalResult(
    this.structure,
    this.name,
  );

  factory OrganicLocalResult.fromResult(OrganicResult result) =>
      OrganicLocalResult(
        result.structure!,
        result.name!,
      );

  factory OrganicLocalResult.fromJson(String body) {
    dynamic json = jsonDecode(body);
    return OrganicLocalResult(
      json['structure'],
      json['name'],
    );
  }

  String toJson() => jsonEncode({
        'structure': structure,
        'name': name,
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganicLocalResult &&
          structure == other.structure &&
          name == other.name;

  @override
  int get hashCode => structure.hashCode ^ name.hashCode;
}
