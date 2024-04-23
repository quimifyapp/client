import 'dart:convert';

import 'package:quimify_client/internet/api/results/balancer_result.dart';

class BalancerLocalResult {
  late final String formula;
  late final String balancedEquation;

  BalancerLocalResult(
    this.formula,
    this.balancedEquation,
  );

  factory BalancerLocalResult.fromResult(BalancerResult result) =>
      BalancerLocalResult(
        result.formula!,
        result.balancedEquation!,
      );

  factory BalancerLocalResult.fromJson(String body) {
    var json = jsonDecode(body);
    return BalancerLocalResult(
      json['formula'],
      json['balancedEquation'],
    );
  }

  String toJson() => jsonEncode({
        'formula': formula,
        'balancedEquation': balancedEquation,
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalancerLocalResult &&
          balancedEquation == other.balancedEquation &&
          formula == other.formula;

  @override
  int get hashCode => balancedEquation.hashCode ^ formula.hashCode;
}
