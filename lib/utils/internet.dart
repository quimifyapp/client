import 'dart:io';

// TODO: not good, doesn't guarantee Internet connection. Remake

// The domain 'example.com' is owned by ICANN and can be used as a reliable
// internet connection checker.
const String testingDomain = 'example.com';

Future<bool> hasInternetConnection() async {
  try {
    final lookup = await InternetAddress.lookup(testingDomain);
    return lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}
