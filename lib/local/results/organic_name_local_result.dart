import 'dart:convert';

import 'package:quimify_client/internet/api/results/organic_result.dart';

class OrganicNameLocalResult {
  late final List<int> sequence;
  late final String? structure;
  late final String name;

  OrganicNameLocalResult(
    this.sequence,
    this.structure,
    this.name,
  );

  factory OrganicNameLocalResult.fromResult(
          OrganicResult result, List<int> sequence) =>
      OrganicNameLocalResult(
        sequence,
        result.structure,
        result.name!,
      );

  factory OrganicNameLocalResult.fromJson(String body) {
    var json = jsonDecode(body);
    return OrganicNameLocalResult(
      json['sequence'].cast<int>(),
      json['structure'],
      json['name'],
    );
  }

  String toJson() => jsonEncode({
        'sequence': sequence,
        'structure': structure,
        'name': name,
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganicNameLocalResult &&
          structure == other.structure &&
          name == other.name;

  @override
  int get hashCode => structure.hashCode ^ name.hashCode;
}
