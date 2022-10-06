import 'package:cliente/api/results/organic_result.dart';
import 'package:cliente/pages/nomenclature/organic/widgets/organic_result_view.dart';
import 'package:cliente/pages/widgets/bars/quimify_page_bar.dart';
import 'package:cliente/pages/widgets/quimify_scaffold.dart';
import 'package:cliente/utils/text.dart';
import 'package:flutter/material.dart';

class OrganicResultPage extends StatelessWidget {
  const OrganicResultPage({Key? key, required this.title, required this.result})
      : super(key: key);

  final String title;
  final OrganicResult result;

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold(
      header: QuimifyPageBar(title: title),
      body: OrganicResultView(
        fields: {
          if (result.name != null) 'Nombre:': result.name!,
          if (result.mass != null) 'Masa molecular:': '${result.mass!} g/mol',
          if (result.structure != null)
            'Fórmula:': formatStructure(result.structure!),
        },
        imageProvider:
            result.url2D != null ? NetworkImage(result.url2D!) : null,
      ),
    );
  }
}
