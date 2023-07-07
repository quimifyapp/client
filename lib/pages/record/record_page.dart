import 'package:flutter/material.dart';
import 'package:quimify_client/pages/record/recordFields.dart';

import '../../api/cache.dart';
import '../widgets/bars/quimify_page_bar.dart';
import '../widgets/quimify_scaffold.dart';

void showRecordPage(BuildContext context, {required bool organic}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => RecordPage(organic: organic),
    ),
  );
}

class RecordPage extends StatelessWidget {
  final bool organic;

  const RecordPage({Key? key, required this.organic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final CacheManager cacheManager = CacheManager();

    return FutureBuilder<List<Map<String, String>>>(
      future: organic
          ? cacheManager.getOrganicFormulas()
          : cacheManager.getMolecularMasses(),
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
            header: const Column(
              children: [
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
