import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
    required this.label,
    required this.icon,
    this.isLoading = false,
    this.onPressed,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
            color: QuimifyColors.primary(context),
            width: 1,
          ),
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          foregroundColor: QuimifyColors.secondaryTeal(context),
        ),
        onPressed: isLoading ? null : onPressed,
        icon: isLoading ? const SizedBox() : icon,
        label: isLoading
            ? const SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 30, 30, 30),
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
