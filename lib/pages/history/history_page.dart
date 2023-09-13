import 'package:flutter/material.dart';
import 'package:quimify_client/pages/history/history_entry.dart';
import 'package:quimify_client/pages/history/widgets/history_entry_view.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    Key? key,
    required this.entries,
    required this.onEntryPressed,
  }) : super(key: key);

  final List<HistoryEntry> entries;
  final void Function(dynamic) onEntryPressed;

  @override
  Widget build(BuildContext context) {
    List<HistoryEntryView> entryViews = entries.reversed
        .map((entry) => HistoryEntryView(
              entry: entry,
              onPressed: (query) {
                Navigator.of(context).pop();
                onEntryPressed(query);
              },
            ))
        .toList();

    return QuimifyScaffold(
      header: const QuimifyPageBar(title: 'Historial'),
      body: entries.isNotEmpty
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                verticalDirection: VerticalDirection.up,
                runSpacing: 25,
                children: entryViews.toList(),
              ),
            )
          : Container(
              // TODO replace with explanatory graphic
              width: double.infinity,
            ),
    );
  }
}
