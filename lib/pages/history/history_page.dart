import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/pages/history/history_entry.dart';
import 'package:quimify_client/pages/history/widgets/history_entry_view.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
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
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      children: [
                        Image.asset( // TODO hide in small screens?
                          'assets/images/empty.png',
                          height: 150,
                        ),
                        const SizedBox(height: 20),
                        AutoSizeText(
                          '¡Ups! Aún no hay nada aquí',
                          maxLines: 1,
                          stepGranularity: 0.1,
                          maxFontSize: 20,
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Los resultados recientes se mostrarán cuando '
                          'hagas tu primera consulta.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16,
                          ),
                          strutStyle: const StrutStyle(height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        QuimifyButton.gradient(
                          height: 50,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Comenzar',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
