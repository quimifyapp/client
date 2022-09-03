import 'package:flutter/material.dart';

import '../../../utils/text.dart';
import '../../../constants.dart';
import '../../../widgets/page_app_bar.dart';
import '../../../widgets/search_bar.dart';

class FindingFormulaPage extends StatelessWidget {
  const FindingFormulaPage({Key? key}) : super(key: key);

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
              PageAppBar(title: 'Formular orgánico'),
              SearchBar(
                hint: 'dietiléter, but-2-eno...',
                corrector: (String input) =>
                    formatOrganicName(input),
              ),
              Expanded(
                child: Container(
                  decoration: bodyBoxDecoration,
                  // To avoid rounded corners overflow:
                  clipBehavior: Clip.hardEdge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
