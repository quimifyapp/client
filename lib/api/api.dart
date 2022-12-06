import 'dart:convert';
import 'dart:io' as io;

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:quimify_client/api/env.dart';
import 'package:quimify_client/api/results/client_result.dart';
import 'package:quimify_client/api/results/inorganic_result.dart';
import 'package:quimify_client/api/results/molecular_mass_result.dart';
import 'package:quimify_client/api/results/organic_result.dart';

class Api {
  static final Api _singleton = Api._internal();

  factory Api() => _singleton;

  Api._internal();

  late final http.Client _client;

  static const _apiVersion = 3;
  static const _clientVersion = 4;
  static const _authority = 'api.quimify.com';

  Future<String?> _getBody(String path, Map<String, dynamic> parameters) async {
    String? response;

    try {
      Uri url = Uri.https(_authority, 'v$_apiVersion/$path', parameters);

      // It's a new query in this session:
      http.Response httpResponse = await _client.get(url);

      if (httpResponse.statusCode == 200) {
        response = utf8.decode(httpResponse.bodyBytes);
      } else {
        // Server bug or invalid URL:
        sendReport(
          label: 'HTTP code ${httpResponse.statusCode}',
          userMessage: url.toString(),
        );
      }
    } catch (_) {} // No Internet connection, server down or client error

    return response;
  }

  // Public:

  Future<void> connect() async {
    io.SecurityContext context = io.SecurityContext(withTrustedRoots: true);

    context.useCertificateChainBytes(utf8.encode(
      '-----BEGIN CERTIFICATE-----\n'
      '${Env.apiCertificate}'
      '\n-----END CERTIFICATE-----\n',
    ));

    context.usePrivateKeyBytes(utf8.encode(
      '-----BEGIN PRIVATE KEY-----\n'
      '${Env.apiPrivateKey}'
      '\n-----END PRIVATE KEY-----\n',
    ));

    _client = io.IOClient(io.HttpClient(context: context));
  }

  Future<ClientResult?> getClientResult() async {
    ClientResult? result;

    int platform = kIsWeb
        ? 2
        : io.Platform.isIOS
            ? 1
            : 0;

    String? response = await _getBody(
      'client/access-data',
      {
        'version': _clientVersion.toString(),
        'platform': platform.toString(),
      },
    );

    if (response != null) {
      try {
        result = ClientResult.fromJson(response);
      } catch (error) {
        sendReport(
          label: 'Access JSON',
          userMessage: error.toString(),
        );
      }
    }

    return result;
  }

  Future<void> sendReport({required String label, String? userMessage}) async {
    Uri url = Uri.https(
      _authority,
      'v$_apiVersion/report',
      {
        'client-version': _clientVersion.toString(),
        'title': label,
        'details': userMessage,
      },
    );

    await _client.post(url);
  }

  Future<String?> getInorganicCompletion(String input) =>
      _getBody('inorganic/completion', {'input': input});

  Future<InorganicResult?> getInorganicFromCompletion(String completion) async {
    InorganicResult? result;

    String? response = await _getBody(
      'inorganic/from-completion',
      {
        'completion': completion,
      },
    );

    if (response != null) {
      try {
        result = InorganicResult.fromJson(response);
      } catch (error) {
        sendReport(
          label: 'Inorganic from completion JSON',
          userMessage: error.toString(),
        );
      }
    }

    return result;
  }

  Future<InorganicResult?> getInorganic(String input, bool picture) async {
    InorganicResult? result;

    String? response = await _getBody(
      'inorganic',
      {
        'input': input,
        'picture': picture.toString(),
      },
    );

    if (response != null) {
      try {
        result = InorganicResult.fromJson(response);
      } catch (error) {
        sendReport(
          label: 'Inorganic JSON',
          userMessage: error.toString(),
        );
      }
    }

    return result;
  }

  Future<MolecularMassResult?> getMolecularMass(String formula) async {
    MolecularMassResult? result;

    String? response = await _getBody(
      'molecular-mass',
      {
        'formula': formula,
      },
    );

    if (response != null) {
      try {
        result = MolecularMassResult.fromJson(response);
      } catch (error) {
        sendReport(
          label: 'Molecular mass JSON',
          userMessage: error.toString(),
        );
      }
    }

    return result;
  }

  Future<OrganicResult?> getOrganicFromName(String name, bool picture) async {
    OrganicResult? result;

    String? response = await _getBody(
      'organic/from-name',
      {
        'name': name,
        'picture': picture.toString(),
      },
    );

    if (response != null) {
      try {
        result = OrganicResult.fromJson(response);
      } catch (error) {
        sendReport(
          label: 'Organic from name JSON',
          userMessage: error.toString(),
        );
      }
    }

    return result;
  }

  Future<OrganicResult?> getOrganicFromStructure(List<int> sequence) async {
    OrganicResult? result;

    String? response = await _getBody(
      'organic/from-structure',
      {
        'structure-sequence': sequence.join(','),
      },
    );

    if (response != null) {
      try {
        result = OrganicResult.fromJson(response);
      } catch (error) {
        sendReport(
          label: 'Organic from structure JSON',
          userMessage: error.toString(),
        );
      }
    }

    return result;
  }
}
