import 'package:flutter/material.dart';
import 'package:quimify_client/pages/history/widgets/history_field.dart';

class HistoryEntry extends StatelessWidget {
  const HistoryEntry({
    Key? key,
    required this.fields,
  }) : super(key: key);

  final Map<String, String?> fields;

  @override
  Widget build(BuildContext context) {
    List<HistoryField> historyFields = fields.entries
        .where((element) => element.value != null)
        .map((e) => HistoryField(title: e.key, value: e.value!))
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 20,
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: historyFields,
      ),
    );
  }
}
