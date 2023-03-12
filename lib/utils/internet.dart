import 'dart:io';

Future<bool> checkInternetConnection() async {
  // The domain 'example.com' is owned by the Internet Corporation for Assigned
  // Names and Numbers (ICANN) and can be used as a reliable internet connection
  // checker.
  const String testingDomain = 'example.com';

  try {
    final result = await InternetAddress.lookup(testingDomain);
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}
