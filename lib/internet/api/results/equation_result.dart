import 'dart:convert';

class EquationResult {
  final bool present;
  final String? balancedReactants;
  final String? balancedProducts;
  final String? error;

  EquationResult(
    this.present,
    this.balancedReactants,
    this.balancedProducts,
    this.error,
  );

  factory EquationResult.fromJson(String body) {
    var json = jsonDecode(body);
    return EquationResult(
      json['present'],
      json['balancedReactants'],
      json['balancedProducts'],
      json['error'],
    );
  }
}
