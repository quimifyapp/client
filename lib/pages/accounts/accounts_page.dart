import 'package:flutter/material.dart';
import 'package:quimify_client/internet/accounts/accounts.dart';
import 'package:quimify_client/internet/payments/payments.dart';
import 'package:quimify_client/pages/accounts/delete_account_dialog.dart';
import 'package:quimify_client/pages/accounts/sign_in_page.dart';
import 'package:quimify_client/pages/accounts/widgets/referral_help_dialog.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final payments = Payments();

    return QuimifyScaffold.noAd(
      header: QuimifyPageBar(title: context.l10n.account),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: QuimifyColors.background(context),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: QuimifyColors.secondaryTeal(context),
                          backgroundImage: authService.photoUrl != null
                              ? NetworkImage(authService.photoUrl!)
                              : null,
                          child: authService.photoUrl == null
                              ? Text(
                                  authService.firstName?[0] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 50,
                                    color: QuimifyColors.inverseText(context),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    context.l10n.userInfo,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          context.l10n.name,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${authService.firstName ?? ''} ${authService.lastName ?? ''}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          context.l10n.email,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          authService.email ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // --- SUSCRIPCIÓN PREMIUM BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => payments.showPaywall(context),
                      icon: const Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                      label: payments.isSubscribed
                          ? Text(context.l10n.subscribed)
                          : Text(context.l10n.premiumSubscription),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: QuimifyColors.teal(),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),

                  // ---------------------------------------------
                  // REFERAL PROGRAM MESSAGE
                  // ---------------------------------------------
                  const SizedBox(height: 16),
                  const InviteCard(), // <--- Our new custom widget
                  const SizedBox(height: 16),

                  // --- CERRAR SESIÓN BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final authService = AuthService();
                        await authService.signOut();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInPage(
                                clientResult: null,
                              ),
                            ),
                            (route) => false, // So it doesn't pop twice
                          );
                        }
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: Text(context.l10n.signOut),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // --- ELIMINAR CUENTA BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const DeleteAccountDialog(),
                        );
                      },
                      icon:
                          const Icon(Icons.delete_forever, color: Colors.white),
                      label: Text(context.l10n.deleteAccount),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// SIMPLE INVITE CARD WIDGET
// ------------------------------------------------------------------
class InviteCard extends StatelessWidget {
  const InviteCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Adjust the padding, margin, color, etc. as you wish
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: QuimifyColors.diagram3dButton(context),
        // example background color
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Emoji or icon
          const Text(
            '💸',
            style: TextStyle(fontSize: 40),
          ),

          const SizedBox(height: 16.0),

          // Title
          Text(
            'GANA DINERO CON QUIMIFY',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8.0),

          // Description
          Text(
            'Gana 10€/\$ por cada 100 mil visitas',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16.0),

          // Bullet points
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check,
                size: 20,
                color: Colors.green,
              ),
              SizedBox(width: 8.0),
              Text(
                '📲 Graba un vídeo',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check, size: 20, color: Colors.green),
              SizedBox(width: 8.0),
              Text(
                '👀 Consigue visitas',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check, size: 20, color: Colors.green),
              SizedBox(width: 8.0),
              Text(
                '💰 Gana Dinero',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          const SizedBox(height: 16.0),

          // Invite button
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>
                    ReferralHelpDialog(), // Show the dialog properly
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Saber más'),
          )
        ],
      ),
    );
  }
}
