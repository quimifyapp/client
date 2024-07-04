import 'package:flutter/material.dart';
import 'package:quimify_client/pages/home/home_page.dart';
import '../../internet/api/results/client_result.dart';
import '../../internet/api/sign-in/google_sign_in_api.dart';
import '../widgets/quimify_colors.dart';

class SignInPage extends StatelessWidget {
  final ClientResult? clientResult;

  const SignInPage({
    Key? key,
    this.clientResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QuimifyColors.background(context),
      body: Center(
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 175,
                ),

                const SizedBox(height: 50),

                // Google Sign-In button
                ElevatedButton.icon(
                  onPressed: () async {
                    final user = await GoogleSignInApi.login();
                    if (user != null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              HomePage(clientResult: clientResult, user: user,)));
                    }
                  },
                  icon: Image.asset('assets/images/icons/google-logo.png',
                      height: 24),
                  label: const Text('Iniciar Sesión con Google'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Apple Sign-In button (assuming you have Apple sign-in set up)
                ElevatedButton.icon(
                  onPressed: () async {
                    // TODO Handle Apple sign-in
                    final user = await GoogleSignInApi.login();
                    if (user != null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              HomePage(clientResult: clientResult, user: user,)));
                    }
                  },
                  icon: const Icon(Icons.apple, color: Colors.white, size: 24),
                  label: const Text('Iniciar Sesión con Apple'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                Image.asset(
                  'assets/images/branding.png',
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
