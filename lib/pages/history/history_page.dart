import 'package:flutter/material.dart';
import 'package:quimify_client/pages/history/widgets/history_entry.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    Key? key,
    required this.title,
    required this.entries,
  }) : super(key: key);

  final String title;
  final List<Map<String, String?>> entries;

  // TODO onPressed to search it
  // TODO handle when it's empty
  // TODO design

  @override
  Widget build(BuildContext context) {
    List<HistoryEntry> historyEntries =
        entries.reversed.map((entry) => HistoryEntry(fields: entry)).toList();

    return QuimifyScaffold(
      header: QuimifyPageBar(
        title: title,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          verticalDirection: VerticalDirection.up,
          runSpacing: 25,
          children: historyEntries,
        ),
      ),
    );
  }
}
