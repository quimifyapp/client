import 'package:flutter/material.dart';

import '../../../utils/text.dart';
import '../../../constants.dart';
import '../../../widgets/page_app_bar.dart';
import '../widgets/search_bar.dart';

class FindingFormulaPage extends StatelessWidget {
  FindingFormulaPage({Key? key}) : super(key: key);

  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

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
              const PageAppBar(title: 'Formular orgánico'),
              SearchBar(
                label: 'dietiléter, but-2-eno...',
                controller: _textController,
                focusNode: _textFocusNode,
                corrector: (String input) =>
                    formatOrganicName(input),
                onSubmitted: (_) {},
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
