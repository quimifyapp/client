import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quimify_client/internet/api/sign-in/sign_in_api.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';

import '../../internet/api/results/client_result.dart';
import 'package:quimify_client/pages/home/home_page.dart';
import '../sign-in/sign_in_page.dart';
import '../widgets/bars/quimify_page_bar.dart';
import '../widgets/dialogs/loading_indicator.dart';
import '../widgets/quimify_colors.dart';

class ProfilePage extends StatelessWidget {
  final ClientResult? clientResult;
  final QuimifyIdentity? user;

  const ProfilePage({
    Key? key,
    this.clientResult,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var defaultLogo = const AssetImage('assets/images/logo.png');
    if (user?.googleUser is GoogleIdentity && user != null) {
      return PopScope(
        onPopInvokedWithResult: (didPop, dynamic) async {
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
                  backgroundImage: user?.photoUrl != null
                      ? NetworkImage(user?.photoUrl ?? '')
                      : defaultLogo,
                ),
                const SizedBox(height: 20),

                Text(
                  'Nombre: ${user?.displayName ?? 'No hay nombre disponible'}', // Use null-ish coalescing operator (??)
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                Text(
                  'Email: ${user?.email}', // Can never be null
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
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()),
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
    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic) async {
        if (!didPop) {
          return;
        }

        hideLoadingIndicator();
      },
      child: QuimifyScaffold.noAd(
        header: const QuimifyPageBar(title: 'Perfil'),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),

                      // Google Sign-In button
                      ElevatedButton.icon(
                        onPressed: () async {
                          final user = await UserAuthService.signInGoogleUser();
                          if (user == null) return;
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => HomePage(
                              clientResult: clientResult,
                              user: user,
                            ),
                          ));
                        },
                        icon: Image.asset(
                          'assets/images/icons/google-logo.png',
                          height: 24,
                        ),
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

                      const SizedBox(height: 50),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
