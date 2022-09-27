import 'package:cliente/api/api.dart';
import 'package:cliente/constants.dart';
import 'package:cliente/organic/types/open_chain/simple.dart';
import 'package:cliente/pages/nomenclature/organic/naming/open_chain/widget/open_chain_builder.dart';
import 'package:cliente/widgets/page_app_bar.dart';
import 'package:flutter/material.dart';

class NamingSimplePage extends StatelessWidget {
  const NamingSimplePage({Key? key}) : super(key: key);

  final String _title = 'Nombrar simple';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: quimifyGradientBoxDecoration,
      child: Scaffold(
        // To avoid keyboard resizing:
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            PageAppBar(title: _title),
            // Body:
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                ),
                // To avoid rounded corners overflow:
                clipBehavior: Clip.hardEdge,
                child: OpenChainBuilder(
                  title: _title,
                  openChain: Simple(),
                  apiGetter: Api().getSimple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
