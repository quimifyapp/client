import 'package:flutter/material.dart';
import 'package:quimify_client/pages/history/history_entry.dart';
import 'package:quimify_client/pages/history/widgets/history_field_view.dart';
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HistoryFieldView(field: entry.firstField),
                  if (entry.secondField != null) ...[
                    const SizedBox(height: 15),
                    HistoryFieldView(field: entry.secondField!),
                  ]
                ],
              ),
            ),
            const SizedBox(width: 15),
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
