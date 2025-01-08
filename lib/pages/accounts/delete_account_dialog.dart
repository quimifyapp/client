import 'package:flutter/material.dart';
import 'package:quimify_client/internet/accounts/accounts.dart';
import 'package:quimify_client/pages/accounts/sign_in_page.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({
    super.key,
  });

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Eliminar Cuenta'),
      content: const Text(
        '¿Estás seguro que deseas eliminar tu cuenta? Esta acción no se puede deshacer.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });

            final success = await AuthService().deleteAccount();

            setState(() {
              _isLoading = false;
            });

            if (success && context.mounted) {
              Navigator.pop(context);

              // Account deletion successful
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInPage(
                    clientResult: null,
                  ),
                ),
                (route) => false, // So it doesn't pop twice
              );
            } else {
              // Show error message to user
              if (context.mounted) {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Error al eliminar la cuenta, cierre sesión y vuelva a iniciar sesión para eliminar la cuenta.')),
                );
              }
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: _isLoading
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(),
                )
              : const Text('Eliminar'),
        ),
      ],
    );
  }
}
