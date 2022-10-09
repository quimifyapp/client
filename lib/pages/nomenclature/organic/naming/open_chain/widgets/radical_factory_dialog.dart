import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_gradient.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_switch.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_dialog.dart';

class RadicalFactoryDialog extends StatefulWidget {
  const RadicalFactoryDialog({Key? key, required this.onSubmitted})
      : super(key: key);

  final void Function(int, bool) onSubmitted;

  Future<void> show(BuildContext context) async =>
      await showQuimifyDialog(context: context, dialog: this);

  @override
  State<RadicalFactoryDialog> createState() => _RadicalFactoryDialogState();
}

class _RadicalFactoryDialogState extends State<RadicalFactoryDialog> {
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
      child: QuimifyDialog(
        title: 'Radical',
        content: Wrap(
          runSpacing: 25,
          children: [
            const QuimifySectionTitle.custom(
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
                              height: 50,
                              backgroundColor:
                                  const Color.fromARGB(255, 56, 133, 224),
                              onPressed: _addButton,
                              child: Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                strutStyle: const StrutStyle(
                                  fontSize: 24,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: QuimifyButton(
                              height: 50,
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 96, 96),
                              enabled: _canRemove(),
                              onPressed: _removeButton,
                              child: Text(
                                '--',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                strutStyle: const StrutStyle(
                                  fontSize: 24,
                                  height: 1.2,
                                ),
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
            const QuimifySectionTitle.custom(
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
        actions: [
          QuimifyButton.gradient(
            height: 50,
            gradient: quimifyGradient,
            onPressed: _doneButton,
            child: Text(
              'Enlazar',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
