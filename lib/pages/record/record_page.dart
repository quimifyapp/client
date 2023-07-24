import 'package:flutter/material.dart';
import 'package:quimify_client/local/history.dart';
import 'package:quimify_client/pages/record/record_fields.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';

showRecordPage(BuildContext context, {required bool organic}) {
  // TODO move?
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => RecordPage(organic: organic),
    ),
  );
}

class RecordPage extends StatelessWidget {
  const RecordPage({
    Key? key,
    required this.organic,
  }) : super(key: key);

  final bool organic;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return FutureBuilder<List<Map<String, String>>>(
      future: organic
          ? History.getOrganicFormulas()
          : History.getMolecularMasses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading while getting record
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // TODO: What to do in order to handle this??
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          // Get full record
          final List<Map<String, String>> history = snapshot.data ?? [];

          return QuimifyScaffold(
            header: Column(
              children: const [
                QuimifyPageBar(title: 'Historial'),
              ],
            ),
            body: ListView.builder(
              controller: scrollController,
              itemCount: history.length,
              itemBuilder: (context, index) {
                final record = history[index];
                return RecordFields(
                  records: [record],
                  context: context,
                );
              },
            ),
          );
        }
      },
    );
  }
}
