import 'package:auto_size_text/auto_size_text.dart';
import 'package:cliente/widgets/button.dart';
import 'package:flutter/material.dart';

import 'package:cliente/widgets/loading.dart';

class PageAppBar extends StatelessWidget {
  const PageAppBar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding:
            const EdgeInsets.only(top: 15, bottom: 25, left: 25, right: 25),
        child: Row(
          children: [
            Button(
              width: 50,
              color: const Color.fromARGB(255, 106, 233, 218),
              onPressed: () {
                Navigator.of(context).pop();
                stopLoading();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: AutoSizeText(
                title,
                maxLines: 1,
                stepGranularity: 0.1,
                maxFontSize: 20,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
