import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quimify_client/internet/api/sign-in/userAuthService.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';

import 'package:quimify_client/internet/api/results/client_result.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/dialogs/loading_indicator.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class ProfilePage extends StatefulWidget {
  final ClientResult? clientResult;
  final Function(QuimifyIdentity?) onUserUpdated;
  QuimifyIdentity? user;

  ProfilePage(
      {Key? key, this.clientResult, required this.onUserUpdated, this.user})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _updateUserProfile() {
    updateUserProfile(UserAuthService.getUser());
  }

  updateUserProfile(QuimifyIdentity? newUser) {
    print("UPDATING USER PROFILE");

    // UPDATE THE PROFILE PAGE
    updateUser(newUser);
    // REBUILD THE PROFILE PAGE
    widget.onUserUpdated(newUser);
  }

  @override
  Widget build(BuildContext context) {
    var defaultLogo = const AssetImage('assets/images/logo.png');
    if (widget.user?.googleUser is GoogleIdentity && widget.user != null) {
      return PopScope(
        onPopInvokedWithResult: (didPop, dynamic) async {
          if (!didPop) {
            return;
          }

          hideLoadingIndicator();
        },
        child: QuimifyScaffold.noAd(
          header:
              QuimifyPageBar(title: 'Perfil', onPressed: _updateUserProfile),
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
                  backgroundImage: widget.user?.photoUrl != null
                      ? NetworkImage(widget.user?.photoUrl ?? '')
                      : defaultLogo,
                ),
                const SizedBox(height: 20),
                Text(
                  'Nombre: ${widget.user?.displayName ?? 'No hay nombre disponible'}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  'Email: ${widget.user?.email}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement the "Gana dinero con Quimify" functionality here
                  },
                  child: const Text('Gana dinero con Quimify'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await UserAuthService.signOut();

                    updateUserProfile(UserAuthService.getUser());
                  },
                  child: const Text('Cerrar Sesión'),
                ),
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
                      ElevatedButton.icon(
                        onPressed: () async {
                          final user =
                              await UserAuthService().signInGoogleUser();
                          if (user == null) return;
                          _updateUserProfile();
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

  void updateUser(QuimifyIdentity? newUser) {
    setState(() {
      widget.user = newUser;
    });
  }
}
