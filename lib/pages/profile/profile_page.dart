import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quimify_client/pages/home/home_page.dart';

import '../../internet/api/results/client_result.dart';
import '../../internet/api/sign-in/google_sign_in_api.dart';

class ProfilePage extends StatelessWidget {
  final GoogleSignInAccount user;
  final ClientResult? clientResult;

  ProfilePage({
    Key? key,
    required this.user,
    this.clientResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Detalles de la cuenta'),
          centerTitle: true,
          actions: [
            ElevatedButton(
              child: Icon(Icons.logout),
              onPressed: () async {
                await GoogleSignInApi.logout();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        HomePage(clientResult: clientResult)));
              },
            )
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Profile', style: TextStyle(fontSize: 24)),
              SizedBox(
                height: 32,
              ),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.photoUrl!),
              ),
              SizedBox(height: 8),
              Text(
                'Nombre: ' + user.displayName!,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                'Email: ' + user.email,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      );
}
