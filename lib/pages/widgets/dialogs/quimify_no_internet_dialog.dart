import 'package:quimify_client/pages/widgets/dialogs/quimify_message_dialog.dart';

const quimifyNoInternetDialog = QuimifyMessageDialog.reportable(
  title: 'Sin conexión',
  details: 'No hay conexión a Internet.',
  reportContext: 'No Intenet connection dialog',
  reportDetails: '',
);