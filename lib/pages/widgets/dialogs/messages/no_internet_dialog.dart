import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/message_dialog.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

MessageDialog noInternetDialog(BuildContext context) =>
    MessageDialog.reportable(
      title: context.l10n.noInternet,
      details: context.l10n.noInternetDetails,
      reportContext: 'No Intenet connection dialog',
      reportDetails: '',
    );
