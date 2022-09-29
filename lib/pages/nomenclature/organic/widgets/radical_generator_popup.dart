import 'package:cliente/constants.dart';
import 'package:cliente/widgets/button.dart';
import 'package:flutter/material.dart';

class RadicalGeneratorPopup extends StatefulWidget {
  const RadicalGeneratorPopup({Key? key}) : super(key: key);

  Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Theme.of(context).colorScheme.shadow,
      anchorPoint: const Offset(0, 0), // Centered
      builder: (BuildContext context) {
        return this;
      },
    );
  }

  @override
  State<RadicalGeneratorPopup> createState() => _RadicalGeneratorPopupState();
}

class _RadicalGeneratorPopupState extends State<RadicalGeneratorPopup> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(25),
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        //titlePadding: EdgeInsets.zero,
        title: Column(
          children: [
            /*
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 25,
                  ),
                  padding:
                      const EdgeInsets.only(top: 17, right: 17, bottom: 10),
                ),
              ],
            ), */
            Text(
              'Radical',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 22,
              ),
            ),
          ],
        ),
        contentPadding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
        content: Text(
                'Hello world',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
        actionsPadding: const EdgeInsets.only(
          bottom: 20,
          left: 15,
          right: 15,
        ),
        actions: [
          Expanded(
            child: Button.gradient(
              gradient: quimifyGradient,
              child: Text(
                'Enlazar',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 17,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
