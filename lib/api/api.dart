import 'dart:convert';
import 'dart:io' as io;

import 'package:cliente/api/results/access_result.dart';
import 'package:cliente/api/results/inorganic_result.dart';
import 'package:cliente/api/results/molecular_mass_result.dart';
import 'package:cliente/api/results/organic_result.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/io_client.dart' as io;

class Api {
  static final Api _singleton = Api._internal();
  factory Api() => _singleton;
  Api._internal();

  late final  _client;

  static const _apiVersion = 0;
  static const _clientVersion = 0;
  static const _authority = 'api.quimify.com';

  Future<void> connect() async {
    io.SecurityContext context = io.SecurityContext(withTrustedRoots: true);

    String ssl = 'assets/ssl';
    context.useCertificateChainBytes(
        (await rootBundle.load('$ssl/certificate.crt')).buffer.asUint8List());
    context.usePrivateKeyBytes(
        (await rootBundle.load('$ssl/private.key')).buffer.asUint8List());

    _client = io.IOClient(io.HttpClient(context: context));
  }

  Future<String?> _getResponse(String path, Map<String, dynamic> params) async {
    String? result;

    try {
      Uri url = Uri.https(_authority, 'v$_apiVersion/$path', params);
      http.Response response = await _client.get(url);

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        result = body;
      } else {
        // Server crash or invalid URL
        // Error...
      }
    } catch (e) {
      print(e.toString());
      // No internet, server down or client error
      // Error...
    }

    return result;
  }

  Future<AccessResult?> getAccess() async {
    AccessResult? result;

    int platform = kIsWeb
        ? 2
        : io.Platform.isIOS
            ? 1
            : 0;

    String? response = await _getResponse('cliente', {
      'version': _clientVersion.toString(),
      'plataforma': platform.toString(),
    });

    if (response != null) {
      try {
        result = AccessResult.fromJson(response);
      } catch (_) {
        // Error...
      }
    }

    return result;
  }

  Future<InorganicResult?> getInorganic(String input, bool photo) async {
    InorganicResult? result;

    String? response = await _getResponse('inorganico', {
      'input': input,
      'foto': photo.toString(),
    });

    if (response != null) {
      try {
        result = InorganicResult.fromJson(response);
      } catch (_) {
        // Error...
      }
    }

    return result;
  }

  Future<MolecularMassResult?> getMolecularMass(String formula) async {
    MolecularMassResult? result;

    String? response = await _getResponse('masamolecular', {
      'formula': formula,
    });

    if (response != null) {
      try {
        result = MolecularMassResult.fromJson(response);
      } catch (_) {
        // Error...
      }
    }

    return result;
  }

  Future<OrganicResult?> getOrganic(String name, bool photo) async {
    OrganicResult? result;

    String? response = await _getResponse('organico/formular', {
      'nombre': name,
      'foto': photo.toString(),
    });

    if (response != null) {
      try {
        result = OrganicResult.fromJson(response);
      } catch (_) {
        // Error...
      }
    }

    return result;
  }

  Future<OrganicResult?> getSimple(List<int> sequence) async {
    OrganicResult? result;

    String? response = await _getResponse('organico/nombrar/simple', {
      'secuencia': sequence.join(','),
    });

    if (response != null) {
      try {
        result = OrganicResult.fromJson(response);
      } catch (_) {
        // Error...
      }
    }

    return result;
  }

  void close() {
    _client.close();
  }
}
