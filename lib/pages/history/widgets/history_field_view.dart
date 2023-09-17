import 'package:flutter/material.dart';
import 'package:quimify_client/pages/history/history_field.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_field.dart';

class HistoryFieldView extends StatelessWidget {
  const HistoryFieldView({
    Key? key,
    required this.field,
  }) : super(key: key);

  final HistoryField field;

  @override
  Widget build(BuildContext context) {
    return QuimifyField(
      title: field.title,
      value: field.value,
      titleColor: quimifyTeal,
    );
  }
}
