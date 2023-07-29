import 'package:flutter/material.dart';
import 'package:quimify_client/pages/history/history_entry.dart';
import 'package:quimify_client/pages/history/widgets/history_field.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';

class HistoryEntryView extends StatelessWidget {
  const HistoryEntryView({
    Key? key,
    required this.entry,
    required this.onPressed,
  }) : super(key: key);

  final HistoryEntry entry;
  final void Function(dynamic) onPressed;

  @override
  Widget build(BuildContext context) {
    List<HistoryField> historyFields = entry.fields.entries
        .where((element) => element.value != null)
        .map((e) => HistoryField(title: e.key, value: e.value!))
        .toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.surface,
      ),
      // To avoid rounded corners overflow:
      clipBehavior: Clip.hardEdge,
      child: MaterialButton(
        padding: const EdgeInsets.all(20),
        splashColor: Colors.transparent,
        onPressed: () => onPressed(entry.query),
        child: Row(
          children: [
            Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 10,
              children: historyFields,
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 30,
              color: quimifyTeal,
            ),
          ],
        ),
      ),
    );
  }
}
