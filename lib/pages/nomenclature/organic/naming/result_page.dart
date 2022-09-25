import 'package:cliente/api/results/organic_result.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../utils/text.dart';
import '../../../../widgets/page_app_bar.dart';
import '../widgets/result_display.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key, required this.title, required this.result})
      : super(key: key);

  final String title;
  final OrganicResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: quimifyGradientBoxDecoration,
      child: Scaffold(
        // To avoid keyboard resizing:
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              PageAppBar(title: title),
              Expanded(
                child: ResultDisplay(
                  firstTitle: 'Nombre:',
                  firstField: result.name!,
                  secondTitle: 'Masa molecular:',
                  secondField: '${result.mass!} g/mol',
                  thirdTitle: 'Fórmula:',
                  thirdField: formatOrganicFormula(result.structure!),
                  imageProvider: NetworkImage(result.url2D!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
