import 'dart:convert';
import 'dart:io' as io;

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:quimify_client/api/env.dart';
import 'package:quimify_client/api/results/access_data_result.dart';
import 'package:quimify_client/api/results/inorganic_result.dart';
import 'package:quimify_client/api/results/molecular_mass_result.dart';
import 'package:quimify_client/api/results/organic_result.dart';

class Api {
  static final Api _singleton = Api._internal();

  factory Api() => _singleton;

  Api._internal();

  late final http.Client _client;

  static const _apiVersion = 4;
  static const _clientVersion = 6;
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
        // Server bug or invalid URL
        sendError(
          context: 'HTTP code ${httpResponse.statusCode}',
          details: url.toString(),
        );
      }
    } catch (error) {
      // No Internet connection, server down or client error
      sendError(
        context: 'Exception during GET request',
        details: error.toString(),
      );
    }

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

  Future<AccessDataResult?> getAccessDataResult() async {
    AccessDataResult? result;

    int platform = kIsWeb
        ? 2
        : io.Platform.isIOS
            ? 1
            : 0;

    String? response = await _getBody(
      'access-data',
      {
        'platform': platform.toString(),
        'client-version': _clientVersion.toString(),
      },
    );

    if (response != null) {
      try {
        result = AccessDataResult.fromJson(response);
      } catch (error) {
        sendError(
          context: 'Access data JSON',
          details: error.toString(),
        );
      }
    }

    return result;
  }

  Future<void> sendError({
    required String context,
    required String details,
  }) async {
    Uri url = Uri.https(
      _authority,
      'v$_apiVersion/client-error',
      {
        'context': context,
        'details': details,
        'client-version': _clientVersion.toString(),
      },
    );

    await _client.post(url);
  }

  Future<void> sendReport({
    required String context,
    required String details,
    String? userMessage,
  }) async {
    Uri url = Uri.https(
      _authority,
      'v$_apiVersion/report',
      {
        'context': context,
        'details': details,
        'user-message': userMessage,
        'client-version': _clientVersion.toString(),
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
        sendError(
          context: 'Inorganic from completion JSON',
          details: error.toString(),
        );
      }
    }

    return result;
  }

  Future<InorganicResult?> getInorganic(String input) async {
    InorganicResult? result;

    String? response = await _getBody(
      'inorganic',
      {
        'input': input,
      },
    );

    if (response != null) {
      try {
        result = InorganicResult.fromJson(response);
      } catch (error) {
        sendError(
          context: 'Inorganic JSON',
          details: error.toString(),
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
        sendError(
          context: 'Molecular mass JSON',
          details: error.toString(),
        );
      }
    }

    return result;
  }

  Future<OrganicResult?> getOrganicFromName(String name) async {
    OrganicResult? result;

    String? response = await _getBody(
      'organic/from-name',
      {
        'name': name,
      },
    );

    if (response != null) {
      try {
        result = OrganicResult.fromJson(response);
      } catch (error) {
        sendError(
          context: 'Organic from name JSON',
          details: error.toString(),
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
        sendError(
          context: 'Organic from structure JSON',
          details: error.toString(),
        );
      }
    }

    return result;
  }
}
