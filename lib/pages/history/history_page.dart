import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/pages/history/history_entry.dart';
import 'package:quimify_client/pages/history/widgets/history_entry_view.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
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
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      color: QuimifyColors.foreground(context),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          // TODO hide in small screens?
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
                            color: QuimifyColors.primary(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Los resultados recientes se mostrarán cuando '
                          'hagas tu primera consulta.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: QuimifyColors.primary(context),
                            fontSize: 16,
                          ),
                          strutStyle: const StrutStyle(height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        QuimifyButton.gradient(
                          height: 50,
                          onPressed: () => _startButtonPressed(context),
                          child: Text(
                            'Comenzar',
                            style: TextStyle(
                              color: QuimifyColors.inverseText(context),
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
