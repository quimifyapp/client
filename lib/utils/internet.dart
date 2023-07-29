import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

// The domain 'example.com' is owned by ICANN and can be used as a reliable
// internet connection checker.

Future<bool> hasInternetConnection() async {
  const int defaultPort = 53;
  const Duration defaultTimeout = Duration(seconds: 10);
  final List<AddressCheckOptions> defaultAddresses = List.unmodifiable([
    AddressCheckOptions(
      InternetAddress('1.1.1.1'),
      port: defaultPort,
      timeout: defaultTimeout,
    ),
    AddressCheckOptions(
      InternetAddress('8.8.4.4'),
      port: defaultPort,
      timeout: defaultTimeout,
    ),
    AddressCheckOptions(
      InternetAddress('9.9.9.9'),
      port: defaultPort,
      timeout: defaultTimeout,
    ),
    AddressCheckOptions(
      InternetAddress('208.67.222.222'),
      port: defaultPort,
      timeout: defaultTimeout,
    ),
  ]);

  // Checking airplane mode
  //TODO: Comprobar en IOS
  final airplanemode = await AirplaneModeChecker.isAirplaneModeOn();
  if (airplanemode == true) {
    print('Airplane mode is on');
    return false;
  }

  // Datos móviles o wifi activos de forma nativa
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  }

  // Comprobación de internet mediante DNS lookup
  List<Future<AddressCheckResult>> requests = [];
  for (var addressOptions in defaultAddresses) {
    requests.add(isHostReachable(addressOptions));
  }

  // Esperar hasta que todas las comprobaciones estén completas
  List<AddressCheckResult> results = await Future.wait(requests);

  // Si alguna comprobación da error o retorna false, retornar false
  for (var result in results) {
    if (!result.isSuccess) {
      return false;
    }
  }

  // Si todas las comprobaciones fueron exitosas, retornar true
  return true;
}

Future<AddressCheckResult> isHostReachable(AddressCheckOptions options) async {
  try {
    final socket = await Socket.connect(
      options.address,
      options.port,
      timeout: options.timeout,
    );
    await socket.close();
    return AddressCheckResult(options, true);
  } catch (_) {
    return AddressCheckResult(options, false);
  }
}

class AddressCheckOptions {
  final InternetAddress address;
  final int port;
  final Duration timeout;

  AddressCheckOptions(
    this.address, {
    this.port = 53,
    this.timeout = const Duration(seconds: 10),
  });

  @override
  String toString() => 'AddressCheckOptions($address, $port, $timeout)';
}

class AddressCheckResult {
  final AddressCheckOptions options;
  final bool isSuccess;

  AddressCheckResult(
    this.options,
    this.isSuccess,
  );

  @override
  String toString() => 'AddressCheckResult($options, $isSuccess)';
}

class AirplaneModeChecker {
  static const MethodChannel _channel = MethodChannel('airplane_mode_checker');

  static Future<bool> isAirplaneModeOn() async {
    try {
      return await _channel.invokeMethod('isAirplaneModeOn');
    } on PlatformException catch (e) {
      print("Failed to check airplane mode: ${e.message}");
      return false;
    }
  }
}
