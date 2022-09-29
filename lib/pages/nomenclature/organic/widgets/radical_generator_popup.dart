import 'package:cliente/constants.dart';
import 'package:cliente/widgets/button.dart';
import 'package:cliente/widgets/section_title.dart';
import 'package:flutter/material.dart';

class RadicalGeneratorPopup extends StatefulWidget {
  const RadicalGeneratorPopup({Key? key, required this.onSubmitted})
      : super(key: key);

  final Function onSubmitted;

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
  void _button() {
    widget.onSubmitted(2, false);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(25),
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Crear radical',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 22,
          ),
        ),
        contentPadding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
        content: Wrap(
          runSpacing: 25,
          children: [
            const SectionTitle.custom(
              title: 'Carbonos:',
              horizontalPadding: 0,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            Wrap(
              direction: Axis.horizontal,
              children: [
                Text(
                  '4',
                ),
                Wrap(
                  direction: Axis.vertical,
                  children: [
                    Button(
                      width: 40,
                      child: Text('+'),
                      color: const Color.fromARGB(255, 56, 133, 224),
                      onPressed: () {},
                    ),
                    Button(
                      width: 40,
                      child: Text('+'),
                      color: const Color.fromARGB(255, 56, 133, 224),
                      onPressed: () {},
                    ),
                  ],
                )
              ],
            ),
            const SectionTitle.custom(
              title: 'Ramificación:',
              horizontalPadding: 0,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.only(
          bottom: 20,
          left: 15,
          right: 15,
        ),
        actions: [
          Button.gradient(
            gradient: quimifyGradient,
            child: Text(
              'Enlazar',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 17,
              ),
            ),
            onPressed: _button,
          ),
        ],
      ),
    );
  }
}
