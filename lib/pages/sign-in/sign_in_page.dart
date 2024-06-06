import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 175,
              ),

              SizedBox(height: 50),

              // Google Sign-In button
              ElevatedButton.icon(
                onPressed: () async {
                  final user = await GoogleSignInApi.login();
                  if (user != null) {
                    Navigator.of(context).pushReplacementNamed('/loading');
                  }
                },
                icon: Image.asset('assets/images/icons/google-logo.png', height: 24),
                label: const Text('Iniciar Sesión con Google'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.black),
                ),
              ),
              SizedBox(height: 20),
              // Apple Sign-In button (assuming you have Apple sign-in set up)
              ElevatedButton.icon(
                onPressed: () {
                  // TODO Handle Apple sign-in
                },
                icon: Icon(Icons.apple, color: Colors.white, size: 24),
                label: Text('Iniciar Sesión con Apple'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),

              SizedBox(height: 50),

              Image.asset(
                'assets/images/branding.png',
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
