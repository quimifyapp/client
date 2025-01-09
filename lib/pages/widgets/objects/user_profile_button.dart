import 'package:flutter/material.dart';
import 'package:quimify_client/internet/accounts/accounts.dart';
import 'package:quimify_client/pages/accounts/accounts_page.dart';
import 'package:quimify_client/pages/accounts/sign_in_page.dart';
import 'package:quimify_client/pages/home/home_page.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class UserProfileButton extends StatelessWidget {
  const UserProfileButton({
    super.key,
    required this.widget,
  });

  final HomePage widget;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        // If user is not signed in, navigate to sign in page
        if (!AuthService().isSignedIn) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => SignInPage(
                clientResult: widget.clientResult,
              ),
            ),
          );
          return;
        }

        // If user is signed in, navigate to AccountsPage
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => const AccountsPage(),
          ),
        );
      },
      child: Icon(
        Icons.account_circle_sharp,
        color: QuimifyColors.inverseText(context),
        size: 40.0,
      ),
    );
  }
}
