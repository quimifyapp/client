import 'dart:convert';

import 'package:quimify_client/api/results/organic_result.dart';

class OrganicFormulaLocalResult {
  late final String? structure;
  late final String name;

  OrganicFormulaLocalResult(
    this.structure,
    this.name,
  );

  factory OrganicFormulaLocalResult.fromResult(OrganicResult result) =>
      OrganicFormulaLocalResult(
        result.structure,
        result.name!,
      );

  factory OrganicFormulaLocalResult.fromJson(String body) {
    var json = jsonDecode(body);
    return OrganicFormulaLocalResult(
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
      other is OrganicFormulaLocalResult &&
          structure == other.structure &&
          name == other.name;

  @override
  int get hashCode => structure.hashCode ^ name.hashCode;
}
