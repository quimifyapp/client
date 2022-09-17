import 'package:cliente/organic/components/functions.dart';
import 'package:cliente/pages/nomenclature/organic/naming/widgets/function_button.dart';
import 'package:flutter/material.dart';

import '../../../../../constants.dart';
import '../../../../../organic/types/simple.dart';
import '../../../../../widgets/page_app_bar.dart';

class NamingSimplePage extends StatefulWidget {
  const NamingSimplePage({Key? key}) : super(key: key);

  @override
  State<NamingSimplePage> createState() => _NamingSimplePageState();
}

class _NamingSimplePageState extends State<NamingSimplePage> {
  final Simple _simple = Simple();

  @override
  void initState() {
    _simple.bondCarbon();
    _simple.bondFunction(Functions.amide);
    super.initState();
  }

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
            const PageAppBar(title: 'Nombrar simple'),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _simple.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                    MaterialButton(
                      onPressed: () => setState(() {
                        _simple.bondCarbon();
                      }),
                      child: Container(
                        color: Colors.green,
                        height: 30,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () => setState(() {
                        _simple.bondFunction(Functions.hydrogen);
                        _simple.bondCarbon();
                      }),
                      child: Container(
                        color: Colors.grey,
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
