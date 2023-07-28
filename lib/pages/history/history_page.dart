import 'package:flutter/material.dart';
import 'package:quimify_client/pages/history/widgets/history_entry.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    Key? key,
    required this.entries,
  }) : super(key: key);

  final List<HistoryEntry> entries;

  // TODO handle when it's empty
  // TODO design

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold(
      header: const QuimifyPageBar(title: 'Historial'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          verticalDirection: VerticalDirection.up,
          runSpacing: 25,
          children: entries.reversed.toList(),
        ),
      ),
    );
  }
}
