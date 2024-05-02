import 'dart:convert';

import 'package:quimify_client/internet/api/results/balancer_result.dart';

class BalancerLocalResult {
  late final String formula;
  late final String balancedEquation;
  late final String balancedReactants;
  late final String balancedProducts;

  BalancerLocalResult(
    this.formula,
    this.balancedEquation,
    this.balancedReactants,
    this.balancedProducts,
  );

  factory BalancerLocalResult.fromResult(BalancerResult result) =>
      BalancerLocalResult(
        result.formula!,
        result.balancedEquation!,
        result.balancedReactants!,
        result.balancedProducts!,
      );

  factory BalancerLocalResult.fromJson(String body) {
    var json = jsonDecode(body);
    return BalancerLocalResult(
      json['formula'],
      json['balancedEquation'],
      json['balancedReactants'],
      json['balancedProducts'],
    );
  }

  String toJson() => jsonEncode({
        'formula': formula,
        'balancedEquation': balancedEquation,
        'balancedReactants': balancedReactants,
        'balancedProducts': balancedProducts,
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalancerLocalResult &&
          formula == other.formula &&
          balancedEquation == other.balancedEquation &&
          balancedReactants == other.balancedReactants &&
          balancedProducts == other.balancedProducts;

  @override
  int get hashCode =>
      formula.hashCode ^
      balancedEquation.hashCode ^
      balancedReactants.hashCode ^
      balancedProducts.hashCode;
}
