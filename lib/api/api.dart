import 'dart:convert';
import 'dart:io' as io;

import 'package:cliente/api/results/access_result.dart';
import 'package:cliente/api/results/inorganic_result.dart';
import 'package:cliente/api/results/molecular_mass_result.dart';
import 'package:cliente/api/results/organic_result.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as io;

class Api {
  static final Api _singleton = Api._internal();

  factory Api() => _singleton;

  Api._internal();

  late final http.Client _client;

  static const _apiVersion = 0;
  static const _clientVersion = 0;
  static const _authority = 'api.quimify.com';

  static String? _lastUrl, _lastResponse;

  Future<void> connect() async {
    io.SecurityContext context = io.SecurityContext(withTrustedRoots: true);

    String dir = 'assets/https';
    context.useCertificateChainBytes(
        (await rootBundle.load('$dir/certificate.crt')).buffer.asUint8List());
    context.usePrivateKeyBytes(
        (await rootBundle.load('$dir/private.key')).buffer.asUint8List());

    _client = io.IOClient(io.HttpClient(context: context));
  }

  Future<String?> _getResponse(String path, Map<String, dynamic> params) async {
    String? response;

    try {
      Uri url = Uri.https(_authority, 'v$_apiVersion/$path', params);

      String urlString = url.toString();

      if (urlString == _lastUrl) {
        return _lastResponse;
      }

      http.Response httpResponse = await _client.get(url);

      if (httpResponse.statusCode == 200) {
        String body = utf8.decode(httpResponse.bodyBytes);
        response = body;
      } else {
        // Server crash or invalid URL
        sendReport(
          label: 'HTTP código $httpResponse.statusCode',
          details: urlString,
        );
      }

      _lastUrl = urlString;
      _lastResponse = response;
    } catch (e) {
      if (false) {
        // No Internet connection
        // TODO
      } else {
        // Server down or client error
        sendReport(label: 'Error al conectarse a la API');
      }
    }

    return response;
  }

  Future<AccessResult?> getAccess() async {
    AccessResult? result;

    int platform = kIsWeb
        ? 2
        : io.Platform.isIOS
            ? 1
            : 0;

    String? response = await _getResponse(
      'cliente',
      {
        'version': _clientVersion.toString(),
        'plataforma': platform.toString(),
      },
    );

    if (response != null) {
      try {
        result = AccessResult.fromJson(response);
      } catch (_) {}
    }

    return result;
  }

  Future<void> sendReport({required String label, String? details}) async {
    Uri url = Uri.https(
      _authority,
      'v$_apiVersion/reporte',
      {
        'version': _clientVersion.toString(),
        'titulo': label,
        'detalles': details,
      },
    );

    await _client.post(url);
  }

  Future<InorganicResult?> getInorganic(String input, bool photo) async {
    InorganicResult? result;

    String? response = await _getResponse(
      'inorganico',
      {
        'input': input,
        'foto': photo.toString(),
      },
    );

    if (response != null) {
      try {
        result = InorganicResult.fromJson(response);
      } catch (_) {}
    }

    return result;
  }

  Future<MolecularMassResult?> getMolecularMass(String formula) async {
    MolecularMassResult? result;

    String? response = await _getResponse(
      'masamolecular',
      {
        'formula': formula,
      },
    );

    if (response != null) {
      try {
        result = MolecularMassResult.fromJson(response);
      } catch (_) {}
    }

    return result;
  }

  Future<OrganicResult?> getOrganicByName(String name, bool picture) async {
    OrganicResult? result;

    String? response = await _getResponse(
      'organic/name',
      {
        'name': name,
        'picture': picture.toString(),
      },
    );

    if (response != null) {
      try {
        result = OrganicResult.fromJson(response);
      } catch (_) {}
    }

    return result;
  }

  Future<OrganicResult?> getOrganic(List<int> structureSequence) async {
    OrganicResult? result;

    String? response = await _getResponse(
      'organic/structure',
      {
        'structure-sequence': structureSequence.join(','),
      },
    );

    if (response != null) {
      try {
        result = OrganicResult.fromJson(response);
      } catch (_) {}
    }

    return result;
  }

  void close() {
    _client.close();
  }
}
