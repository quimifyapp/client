import 'dart:convert';

import 'package:quimify_client/internet/api/results/equation_result.dart';

class EquationLocalResult {
  late final String originalReactants;
  late final String originalProducts;
  late final String balancedReactants;
  late final String balancedProducts;

  EquationLocalResult(
    this.originalReactants,
    this.originalProducts,
    this.balancedReactants,
    this.balancedProducts,
  );

  factory EquationLocalResult.fromResult(EquationResult result,
          String originalReactants, String originalProducts) =>
      EquationLocalResult(
        originalReactants,
        originalProducts,
        result.balancedReactants!,
        result.balancedProducts!,
      );

  factory EquationLocalResult.fromJson(String body) {
    var json = jsonDecode(body);
    return EquationLocalResult(
      json['originalReactants'],
      json['originalProducts'],
      json['balancedReactants'],
      json['balancedProducts'],
    );
  }

  String toJson() => jsonEncode({
        'originalReactants': originalReactants,
        'originalProducts': originalProducts,
        'balancedReactants': balancedReactants,
        'balancedProducts': balancedProducts,
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquationLocalResult &&
          originalReactants == other.originalReactants &&
          originalProducts == other.originalProducts &&
          balancedReactants == other.balancedReactants &&
          balancedProducts == other.balancedProducts;

  @override
  int get hashCode =>
      originalReactants.hashCode ^
      originalProducts.hashCode ^
      balancedReactants.hashCode ^
      balancedProducts.hashCode;
}
