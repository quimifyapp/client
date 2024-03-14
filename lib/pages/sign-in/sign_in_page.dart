import 'package:flutter/material.dart';
import '../../internet/api/sign-in/google_sign_in_api.dart';
import 'package:quimify_client/pages/profile/profile_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => signIn(context), // Pass the context here.
          icon: Icon(Icons.email),
          label: Text('Sign Up with Google'),
        ),
      ],
    );
  }

  Future signIn(BuildContext context) async { // Accept the context here.
    final user = await GoogleSignInApi.login();

    if (user == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign In Failed')),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
      );
    }
  }
}

