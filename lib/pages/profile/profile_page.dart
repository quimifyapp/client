import 'package:flutter/material.dart';
import 'package:quimify_client/internet/api/sign-in/sign_in_api.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';

import '../../internet/api/results/client_result.dart';
import '../sign-in/sign_in_page.dart';
import '../widgets/bars/quimify_page_bar.dart';
import '../widgets/dialogs/loading_indicator.dart';
import '../widgets/quimify_colors.dart';

class ProfilePage extends StatelessWidget {
  final ClientResult? clientResult;
  final QuimifyIdentity user;

  const ProfilePage({
    Key? key,
    this.clientResult,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          return;
        }

        hideLoadingIndicator();
      },
      child: QuimifyScaffold.noAd(
        header: const QuimifyPageBar(title: 'Perfil'),
        body: Container(
          width: 900,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: QuimifyColors.foreground(context),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              CircleAvatar(
                radius: 50,
                // TODO: Make it locally
                backgroundImage: NetworkImage(user.photoUrl ??
                    'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg'),
              ),

              const SizedBox(height: 20),

              Text(
                'Nombre: ${user.displayName}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Text(
                'Email: ${user.email}', // Can never be null
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  // Implement the "Gana dinero con Quimify" functionality here
                },
                child: const Text('Gana dinero con Quimify'),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  await UserAuthService.signOut();
                  // Navigate back to the sign-in screen after signing out
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
                child: const Text('Cerrar Sesión'),
              ),
              //const SizedBox(height: 15),
              //const SizedBox(height: 5), // + 15 from cards = 20
            ],
          ),
        ),
      ),
    );
  }
}
