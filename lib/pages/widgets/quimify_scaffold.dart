import 'package:cliente/pages/widgets/appearance/quimify_gradient.dart';
import 'package:flutter/material.dart';

class QuimifyScaffold extends StatelessWidget {
  const QuimifyScaffold({Key? key, required this.header, required this.body})
      : super(key: key);

  final Widget header, body;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: quimifyGradient,
      ),
      child: Scaffold(
        // To avoid keyboard resizing:
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            header,
            Expanded(
              child: Container(
                // To avoid rounded corners overflow:
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: body),
            ),
          ],
        ),
      ),
    );
  }
}
