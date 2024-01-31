import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quimify_client/pages/organic/naming/widgets/radical_factory/carbons_help_dialog.dart';
import 'package:quimify_client/pages/organic/naming/widgets/radical_factory/tip_shape_help_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/message_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_dialog.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_switch.dart';

class RadicalFactoryDialog extends StatefulWidget {
  const RadicalFactoryDialog({
    Key? key,
    required this.onSubmitted,
  }) : super(key: key);

  final Function(int, bool) onSubmitted;

  show(BuildContext context) async =>
      await showQuimifyDialog(context: context, dialog: this);

  @override
  State<RadicalFactoryDialog> createState() => _RadicalFactoryDialogState();
}

class _RadicalFactoryDialogState extends State<RadicalFactoryDialog> {
  late int _carbonCount;
  late bool _isIso;

  @override
  initState() {
    super.initState();

    _carbonCount = 1;
    _isIso = false;
  }

  _pressedDoneButton() {
    widget.onSubmitted(_carbonCount, _isIso);
    Navigator.of(context).pop();
  }

  _pressedAddButton() => setState(() => _carbonCount++);

  bool _canRemove() => _carbonCount > (_isIso ? 3 : 1);

  _pressedRemoveButton() {
    if (_canRemove()) {
      setState(() => _carbonCount--);
    } else {
      MessageDialog(
        title: 'No existe',
        details: 'Un radical ${_isIso ? 'con esa terminación ' : ''}debe '
            'tener al menos ${_isIso ? '3 carbonos' : '1 carbono'}.',
      ).show(context);
    }
  }

  _pressedSwitchButton(bool newValue) {
    setState(() {
      _isIso = newValue;
      if (_isIso && _carbonCount <= 3) {
        _carbonCount = 3;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return QuimifyDialog(
      title: 'Radical',
      content: [
        const QuimifySectionTitle.custom(
          title: 'Carbonos',
          horizontalPadding: 0,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          helpDialog: CarbonsHelpDialog(),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
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
                            color: const Color.fromARGB(255, 56, 133, 224),
                            onPressed: _pressedAddButton,
                            child: Text(
                              '+',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onPrimary,
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
                            color: const Color.fromARGB(255, 255, 96, 96),
                            enabled: _canRemove(),
                            onPressed: _pressedRemoveButton,
                            child: Text(
                              '–',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onPrimary,
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
        ),
        const QuimifySectionTitle.custom(
          title: 'Terminación',
          horizontalPadding: 0,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          helpDialog: TipShapeHelpDialog(),
        ),
        Center(
          child: Wrap(
            direction: Axis.horizontal,
            children: [
              IndexedStack(
                index: _isIso ? 1 : 0,
                children: [
                  Image.asset(
                    'assets/images/icons/straight-radical.png',
                    height: 70,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Image.asset(
                    'assets/images/icons/iso-radical.png',
                    height: 70,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(width: 40),
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: QuimifySwitch(
                  value: _isIso,
                  onChanged: _pressedSwitchButton,
                ),
              ),
            ],
          ),
        ),
      ],
      actions: [
        QuimifyButton.gradient(
          height: 50,
          onPressed: _pressedDoneButton,
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
    );
  }
}
