import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

const Duration _timeout = Duration(seconds: 5);

const int _dnsPort = 53;

const String _cloudflareDnsIp = '1.1.1.1';
const String _googleDnsIp = '8.8.8.8';

final List<String> _dnsIps = [
  _cloudflareDnsIp,
  _googleDnsIp,
];

Future<bool> _hasNoConnection() async =>
    await Connectivity().checkConnectivity() == ConnectivityResult.none;

Future<bool> _isReachable(String ip) async {
  try {
    (await Socket.connect(ip, _dnsPort, timeout: _timeout)).close();
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> hasInternetConnection() async {
  if (await _hasNoConnection()) {
    return false;
  }

  for (String ip in _dnsIps) {
    if (await _isReachable(ip)) {
      return true;
    }
  }

  return false;
}
