import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/message_dialog.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

// Create a function that returns a MessageDialog with localized strings
MessageDialog comingSoonDialog(BuildContext context) => MessageDialog(
      title: context.l10n.comingSoon,
      details: context.l10n.comingSoonDetails,
    );
