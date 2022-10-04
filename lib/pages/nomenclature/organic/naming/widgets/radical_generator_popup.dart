import 'dart:ui';

import 'package:cliente/pages/widgets/quimify_button.dart';
import 'package:cliente/pages/widgets/quimify_gradient.dart';
import 'package:cliente/pages/widgets/quimify_switch.dart';
import 'package:cliente/pages/widgets/section_title.dart';
import 'package:flutter/material.dart';

class RadicalGeneratorPopup extends StatefulWidget {
  const RadicalGeneratorPopup({Key? key, required this.onSubmitted})
      : super(key: key);

  final void Function(int, bool) onSubmitted;

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

  void _addButton() => setState(() => _carbonCount++);

  bool _canRemove() => _carbonCount > (_isIso ? 3 : 1);

  void _removeButton() => setState(() => _carbonCount--);

  void _switchButton(bool newValue) {
    setState(() {
      _isIso = newValue;
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
            const EdgeInsets.only(top: 20, bottom: 35, left: 25, right: 25),
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
              child: SizedBox(
                height: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$_carbonCount',
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w500,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 40,
                      child: Column(
                        children: [
                          const SizedBox(height: 2),
                          Expanded(
                            child: QuimifyButton(
                              color: const Color.fromARGB(255, 56, 133, 224),
                              onPressed: _addButton,
                              child: Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                strutStyle:
                                    const StrutStyle(fontSize: 24, height: 1.2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: QuimifyButton(
                              color: const Color.fromARGB(255, 255, 96, 96),
                              enabled: _canRemove(),
                              onPressed: _removeButton,
                              child: Text(
                                '--',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                strutStyle:
                                    const StrutStyle(fontSize: 24, height: 1.2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SectionTitle.custom(
              title: 'Terminación:',
              horizontalPadding: 0,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 30),
            Center(
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  IndexedStack(
                    index: _isIso ? 1 : 0,
                    children: [
                      Image.asset(
                        'assets/images/icons/straight-radical.png',
                        height: 65,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Image.asset(
                        'assets/images/icons/iso-radical.png',
                        height: 65,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: QuimifySwitch(
                      value: _isIso,
                      onChanged: _switchButton,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.only(
          bottom: 20,
          left: 15,
          right: 15,
        ),
        actions: [
          QuimifyButton.gradient(
            gradient: quimifyGradient,
            onPressed: _doneButton,
            child: Text(
              'Enlazar',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
