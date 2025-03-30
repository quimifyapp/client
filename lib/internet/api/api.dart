import 'dart:convert';
import 'dart:io' as io;

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as io;
import 'package:quimify_client/internet/api/env/env.dart';
import 'package:quimify_client/internet/api/results/client_result.dart';
import 'package:quimify_client/internet/api/results/inorganic_result.dart';
import 'package:quimify_client/internet/api/results/molecular_mass_result.dart';
import 'package:quimify_client/internet/api/results/organic_result.dart';
import 'package:quimify_client/internet/internet.dart';
import 'package:quimify_client/internet/api/results/equation_result.dart';

class Api {
  static final Api _singleton = Api._internal();

  factory Api() => _singleton;

  Api._internal();

  late final http.Client _client;

  // Constants:

  static const _httpStatusCodeOk = 200;
  
  static const _apiVersion = 6;
  static const _clientVersion = 20;

  static const _authority = 'api.quimify.com';
  static const _mirrorAuthority = 'api2.quimify.com';
  
  static const _timeout = Duration(seconds: 15);

  // Initialize:

  initialize() {
    var context = io.SecurityContext(withTrustedRoots: true);

    context.useCertificateChainBytes(utf8.encode(
      '-----BEGIN CERTIFICATE-----\n'
      '${Env.apiCertificate}\n'
      '-----END CERTIFICATE-----',
    ));

    context.usePrivateKeyBytes(utf8.encode(
      '-----BEGIN PRIVATE KEY-----\n'
      '${Env.apiPrivateKey}\n'
      '-----END PRIVATE KEY-----',
    ));

    _client = io.IOClient(io.HttpClient(context: context));
  }

  // Private:

  String _versionedPath(String path) => 'v$_apiVersion/$path';

  Future<String?> _getBody(String authority, String path, parameters) async {
    String? response;

    Uri url = Uri.https(authority, path, parameters);

    try {
      http.Response httpResponse = await _client.get(url).timeout(_timeout);

      if (httpResponse.statusCode == _httpStatusCodeOk) {
        response = utf8.decode(httpResponse.bodyBytes);
      } else {
        // Server bug or invalid URL
        sendError(
          context: 'HTTP code ${httpResponse.statusCode}',
          details: url.toString(),
        );
      }
    } catch (error) {
      hasInternetConnection().then((hasInternetConnection) {
        if (hasInternetConnection) {
          // Server down or client error
          sendError(
            context: 'Error attempting GET request: $error',
            details: url.toString(),
          );
        }
      });
    }

    return response;
  }

  Future<String?> _getBodyWithRetry(String path, parameters) async {
    path = _versionedPath(path);

    return await _getBody(_authority, path, parameters) ??
        await _getBody(_mirrorAuthority, path, parameters); // Retry
  }

  Future<bool> _post(Uri url) async {
    bool posted;

    try {
      http.Response httpResponse = await _client.post(url);
      posted = httpResponse.statusCode == _httpStatusCodeOk;
    } catch (error) {
      // No Internet connection, server down or client error
      posted = false;
    }

    return posted;
  }

  Future<bool> _sendError({
    required String authority,
    required String context,
    required String details,
  }) {
    Uri url = Uri.https(
      authority,
      _versionedPath('client-error'),
      {
        'context': context,
        'details': details,
        'client-version': _clientVersion.toString(),
      },
    );

    return _post(url);
  }

  Future<bool> _sendReport({
    required String authority,
    required String context,
    required String details,
    String? userMessage,
  }) {
    Uri url = Uri.https(
      authority,
      _versionedPath('report'),
      {
        'context': context,
        'details': details,
        'user-message': userMessage,
        'client-version': _clientVersion.toString(),
      },
    );

    return _post(url);
  }

  // Public:

  Future<ClientResult?> getClient() async {
    ClientResult? result;

    String? response = await _getBodyWithRetry(
      'client',
      {
        'platform': io.Platform.isAndroid ? 'android' : 'ios',
        'version': _clientVersion.toString(),
      },
    );

    if (response != null) {
      try {
        result = ClientResult.fromJson(response);
      } catch (error) {
        sendError(
          context: 'Client JSON',
          details: error.toString(),
        );
      }
    }

    return result;
  }

  sendError({
    required String context,
    required String details,
  }) async {
    bool posted = await _sendError(
      authority: _authority,
      context: context,
      details: details,
    );

    if (!posted) {
      _sendError(
        authority: _mirrorAuthority,
        context: context,
        details: details,
      );
    }
  }

  sendReportWithRetry({
    required String context,
    required String details,
    String? userMessage,
  }) async {
    bool posted = await _sendReport(
      authority: _authority,
      context: context,
      details: details,
      userMessage: userMessage,
    );

    if (!posted) {
      _sendReport(
        authority: _mirrorAuthority,
        context: context,
        details: details,
        userMessage: userMessage,
      );
    }
  }

  Future<String?> getInorganicCompletion(String input) =>
      _getBodyWithRetry('inorganic/completion', {'input': input});

  Future<InorganicResult?> getInorganicFromCompletion(String completion) async {
    InorganicResult? result;

    String? response = await _getBodyWithRetry(
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

  Future<InorganicResult?> searchInorganic(String input) async {
    InorganicResult? result;

    String? response = await _getBodyWithRetry(
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

  Future<InorganicResult?> deepSearchInorganic(String input) async {
    InorganicResult? result;

    String? response = await _getBodyWithRetry(
      'inorganic/deep',
      {
        'input': input,
      },
    );

    if (response != null) {
      try {
        result = InorganicResult.fromJson(response);
      } catch (error) {
        sendError(
          context: 'Inorganic deep JSON',
          details: error.toString(),
        );
      }
    }

    return result;
  }

  Future<MolecularMassResult?> getMolecularMass(String formula) async {
    MolecularMassResult? result;

    String? response = await _getBodyWithRetry(
      'molecular-mass',
      {
        'formula': formula,
      },
    );

    if (response != null) {
      try {
        result = MolecularMassResult.fromJson(response, formula);
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

    String? response = await _getBodyWithRetry(
      'organic/structure',
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

    String? response = await _getBodyWithRetry(
      'organic/name',
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

  Future<EquationResult?> getEquation(String reactants, String products) async {
    EquationResult? result;

    String? response = await _getBodyWithRetry(
      'equation',
      {
        'reactants': reactants,
        'products': products,
      },
    );

    if (response != null) {
      try {
        result = EquationResult.fromJson(response);
      } catch (error) {
        sendError(
          context: 'Equation JSON',
          details: error.toString(),
        );
      }
    }

    return result;
  }
}
