import 'package:flutter/material.dart';
import 'package:quimify_client/internet/api/sign-in/userAuthService.dart';
import 'package:quimify_client/pages/profile/profile_page.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar({Key? key}) : super(key: key);

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  QuimifyIdentity? user = UserAuthService.getUser();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 38,
        alignment: Alignment.centerRight,
        icon: user?.photoUrl != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(user?.photoUrl ?? ''),
                radius: 19,
              )
            : Icon(
                Icons.account_circle,
                color: QuimifyColors.inverseText(context),
              ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                onUserUpdated: updateUser,
                user: user,
              ),
            ),
          );
        },
      ),
    );
  }

  void updateUser(QuimifyIdentity? newUser) {
    // Update the user state, so the page gets updated.
    setState(() {
      user = newUser;
    });
  }
}
