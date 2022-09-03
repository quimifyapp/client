import 'dart:convert';

import 'package:cliente/api/results/access_result.dart';
import 'package:cliente/api/results/molecular_mass_result.dart';
import 'package:http/http.dart' as http;

class Api {
  final _client = http.Client();

  Api._internal();
  static final _singleton = Api._internal();

  static const String authority = '192.168.1.90:8080';

  factory Api() => _singleton;

  Future<MolecularMassResult?> getMolecularMass(String formula) async {
    MolecularMassResult? result;

    try {
      Uri url = Uri.http(authority, 'masamolecular', {'formula': formula});
      http.Response response = await _client.get(url);

      if(response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        result = MolecularMassResult.fromJson(body);
      } else {
        // Server crash or invalid URL
        // Error...
      }
    } catch (_) {
      // No internet, server down or client error
      // Error...
    }

    return result;
  }

  Future<AccessResult?> connect() async {
    AccessResult? result;

    try {
      Uri url = Uri.http(authority, 'bienvenida');
      http.Response response = await _client.get(url);

      if(response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        result = AccessResult.fromJson(body);
      } else {
        // Server crash or invalid URL
        // Error...
      }
    } catch (_) {
      // No internet, server down or client error
      // Error...
    }

    return result;
  }

  void close() {
    _client.close();
  }
}
