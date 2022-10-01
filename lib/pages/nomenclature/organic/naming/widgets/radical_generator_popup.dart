import 'dart:ui';

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
      anchorPoint: const Offset(0, 0),
      // Centered
      builder: (BuildContext context) {
        return this;
      },
    );
  }

  @override
  State<RadicalGeneratorPopup> createState() => _RadicalGeneratorPopupState();
}

class _RadicalGeneratorPopupState extends State<RadicalGeneratorPopup> {
  late int _carbonCount;
  late bool _isIso;

  @override
  void initState() {
    _carbonCount = 1;
    _isIso = false;
    super.initState();
  }

  void _doneButton() {
    widget.onSubmitted(_carbonCount, _isIso);
    Navigator.of(context).pop();
  }

  void _addButton() {
    setState(() => _carbonCount++);
  }

  bool _canRemove() => _carbonCount > (_isIso ? 3 : 1);

  void _removeButton() {
    setState(() => _carbonCount--);
  }

  void _switchButton(bool value) {
    setState(() {
      _isIso = value;
      if (_isIso && _carbonCount <= 3) {
        _carbonCount = 3;
      }
    });
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
          'Radical',
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
            Center(
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 30,
                      bottom: 30,
                      left: 40,
                      right: 40,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$_carbonCount',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Wrap(
                    direction: Axis.vertical,
                    children: [
                      const SizedBox(height: 2),
                      Button(
                        width: 45,
                        height: 45,
                        color: const Color.fromARGB(255, 56, 133, 224),
                        onPressed: _addButton,
                        child: const Text(
                          '+',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                          ),
                          strutStyle: StrutStyle(fontSize: 24, height: 1.2),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Button(
                        width: 45,
                        height: 45,
                        color: const Color.fromARGB(255, 255, 96, 96),
                        enabled: _canRemove(),
                        onPressed: _removeButton,
                        child: const Text(
                          '--',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                          ),
                          strutStyle: StrutStyle(fontSize: 24, height: 1.2),
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                  )
                ],
              ),
            ),
            const SectionTitle.custom(
              title: 'Complegidad:',
              horizontalPadding: 0,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 30),
            Center(
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  Image.asset(
                    'assets/images/icons/iso-radical.png',
                    width: 110,
                  ),
                  const SizedBox(width: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Transform.scale(
                      scale: 1.2,
                      child: Switch(
                        activeColor: Colors.white.withOpacity(0.9),
                        inactiveThumbColor: Colors.white.withOpacity(0.9),
                        activeTrackColor: quimifyTeal,
                        inactiveTrackColor:
                            Theme.of(context).colorScheme.secondary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: _isIso,
                        onChanged: _switchButton,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 75),
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
            onPressed: _doneButton,
            child: Text(
              'Enlazar',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }
}
