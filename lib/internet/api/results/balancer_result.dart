import 'dart:convert';

class BalancerResult {
  final String? formula;
  final bool present;
  final String? originalEquation;
  final String? balancedEquation;
  final String? error;

  BalancerResult(
    this.formula,
    this.present,
    this.originalEquation,
    this.balancedEquation,
    this.error,
  );

  factory BalancerResult.fromJson(String body, String formula) {
    var json = jsonDecode(body);
    return BalancerResult(
      formula,
      json['present'],
      json['originalEquation'],
      json['balancedEquation'],
      json['error'],
    );
  }
}
