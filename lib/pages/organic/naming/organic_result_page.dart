import 'package:quimify_client/pages/organic/widgets/organic_result_view.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:flutter/material.dart';

class OrganicResultPage extends StatelessWidget {
  const OrganicResultPage({
    Key? key,
    required this.title,
    required this.organicResultView,
  }) : super(key: key);

  final String title;
  final OrganicResultView organicResultView;

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold(
      bannerAdName: runtimeType.toString(),
      header: QuimifyPageBar(title: title),
      body: organicResultView,
    );
  }
}
