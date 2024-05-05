import 'package:flutter/material.dart';
import 'package:quimify_client/pages/history/history_entry.dart';
import 'package:quimify_client/pages/history/widgets/history_entry_view.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_mascot_message.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    Key? key,
    required this.onStartPressed,
    required this.entries,
    required this.onEntryPressed,
  }) : super(key: key);

  final VoidCallback onStartPressed;
  final List<HistoryEntry> entries;
  final void Function(dynamic) onEntryPressed;

  _startButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    onStartPressed();
  }

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
      showBannerAd: entries.isNotEmpty,
      bannerAdName: runtimeType.toString(),
      header: const QuimifyPageBar(title: 'Historial'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: entries.isNotEmpty
            ? Wrap(
                verticalDirection: VerticalDirection.up,
                runSpacing: 15,
                children: entryViews.toList(),
              )
            : QuimifyMascotMessage(
                tone: QuimifyMascotTone.negative,
                title: '¡Ups! Aún no hay nada aquí',
                details: 'Los resultados recientes se mostrarán cuando hagas '
                    'tu primera consulta.',
                buttonLabel: 'Comenzar',
                onButtonPressed: () => _startButtonPressed(context),
              ),
      ),
    );
  }
}
