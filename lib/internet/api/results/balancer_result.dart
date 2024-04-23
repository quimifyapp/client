import 'dart:convert';

class BalancerResult {
  final bool present;
  final String? originalEquation;
  final String? balancedEquation;
  final String? error;

  BalancerResult(
    this.present,
    this.originalEquation,
    this.balancedEquation,
    this.error,
  );

  factory BalancerResult.fromJson(String body, String formula) {
    var json = jsonDecode(body);
    return BalancerResult(
      json['present'],
      json['originalEquation'],
      json['balancedEquation'],
      json['error'],
    );
  }
}
