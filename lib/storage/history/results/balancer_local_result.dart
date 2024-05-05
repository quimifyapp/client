import 'dart:convert';

import 'package:quimify_client/internet/api/results/balancer_result.dart';

class BalancerLocalResult {
  late final String originalReactants;
  late final String originalProducts;
  late final String balancedReactants;
  late final String balancedProducts;

  BalancerLocalResult(
    this.originalReactants,
    this.originalProducts,
    this.balancedReactants,
    this.balancedProducts,
  );

  factory BalancerLocalResult.fromResult(BalancerResult result) =>
      BalancerLocalResult(
        result.originalReactants!,
        result.originalProducts!,
        result.balancedReactants!,
        result.balancedProducts!,
      );

  factory BalancerLocalResult.fromJson(String body) {
    var json = jsonDecode(body);
    return BalancerLocalResult(
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
      other is BalancerLocalResult &&
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
