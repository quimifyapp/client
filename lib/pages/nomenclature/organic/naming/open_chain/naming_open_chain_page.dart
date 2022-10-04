import 'dart:ui';

import 'package:cliente/api/api.dart';
import 'package:cliente/api/results/organic_result.dart';
import 'package:cliente/organic/components/functional_group.dart';
import 'package:cliente/organic/components/substituent.dart';
import 'package:cliente/organic/compounds/open_chain/ether.dart';
import 'package:cliente/organic/compounds/open_chain/open_chain.dart';
import 'package:cliente/organic/compounds/open_chain/simple.dart';
import 'package:cliente/pages/nomenclature/organic/naming/organic_result_page.dart';
import 'package:cliente/pages/widgets/quimify_gradient.dart';
import 'package:cliente/pages/widgets/quimify_scaffold.dart';
import 'package:cliente/pages/widgets/quimify_switch.dart';
import 'package:cliente/pages/widgets/quimify_teal.dart';
import 'package:cliente/utils/text.dart';
import 'package:cliente/pages/widgets/quimify_button.dart';
import 'package:cliente/pages/widgets/quimify_dialog.dart';
import 'package:cliente/pages/widgets/quimify_loading.dart';
import 'package:cliente/pages/widgets/quimify_page_bar.dart';
import 'package:cliente/pages/widgets/quimify_section_title.dart';
import 'package:flutter/material.dart';

class NamingOpenChainPage extends StatefulWidget {
  const NamingOpenChainPage({Key? key}) : super(key: key);

  @override
  State<NamingOpenChainPage> createState() => _NamingOpenChainPageState();
}

class _NamingOpenChainPageState extends State<NamingOpenChainPage> {
  static const String _title = 'Nombrar cadena abierta';

  late List<OpenChain> _openChainStack;
  late List<List<int>> _inputSequenceStack;
  late bool _done;

  void _reset() {
    _openChainStack = [Simple()];
    _inputSequenceStack = [[]];
    _done = false;
  }

  @override
  void initState() {
    _reset();
    super.initState();
  }

  Future<OrganicResult?> _search() async {
    startLoading(context);

    OrganicResult? result = await Api().getOrganic(_inputSequenceStack.last);

    stopLoading();

    if (result != null) {
      if (!result.present) {
        if (!mounted) return null; // For security reasons
        const QuimifyDialog.message(
          title: 'Sin resultado',
        ).show(context);

        return null;
      }
    } else {
      // Client already reported an error in this case
      if (!mounted) return null; // For security reasons
      const QuimifyDialog.message(
        title: 'Sin resultado',
      ).show(context);
    }

    return result;
  }

  void _pressedButton() {
    if (_done) {
      _search().then(
        (organicResult) {
          setState(_reset);

          if (organicResult != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return OrganicResultPage(
                    title: _title,
                    result: organicResult,
                  );
                },
              ),
            );
          }
        },
      );
    }
  }

  void _checkDone() {
    setState(() => _done = _openChainStack.last.isDone());
  }

  void _startEditing() {
    _openChainStack.add(_openChainStack.last.getCopy());
    _inputSequenceStack.add(List.from(_inputSequenceStack.last));
  }

  bool _canBondCarbon() =>
      [1, 2, 3].contains(_openChainStack.last.getFreeBonds());

  void _bondCarbon() {
    if (_canBondCarbon()) {
      _startEditing();
      setState(() {
        _openChainStack.last.bondCarbon();
        _inputSequenceStack.last.add(-1);
        _checkDone();
      });
    }
  }

  bool _canHydrogenate() => _openChainStack.last.getFreeBonds() > 0;

  void _hydrogenate() {
    if (_canHydrogenate()) {
      _startEditing();
      setState(() {
        int limit = _openChainStack.last.getFreeBonds() > 1 ? 1 : 0;
        while (_openChainStack.last.getFreeBonds() > limit) {
          int code = _openChainStack.last
              .getOrderedBondableGroups()
              .indexOf(FunctionalGroup.hydrogen);
          if (code != -1) {
            _openChainStack.last.bondFunctionalGroup(FunctionalGroup.hydrogen);
            _inputSequenceStack.last.add(code);
            _checkDone();
          }
        }
      });
    }
  }

  bool _canUndo() => _openChainStack.length > 1;

  void _undo() {
    if (_canUndo()) {
      setState(() {
        _openChainStack.removeLast();
        _inputSequenceStack.removeLast();
        _checkDone();
      });
    }
  }

  void _bondRadical(int carbonCount, bool isIso) {
    _startEditing();

    setState(() {
      int code = _openChainStack.last
          .getOrderedBondableGroups()
          .indexOf(FunctionalGroup.radical);

      if (code != -1) {
        _openChainStack.last
            .bondSubstituent(Substituent.radical(carbonCount, isIso));

        _inputSequenceStack.last.add(code);
        _inputSequenceStack.last.add(isIso ? 1 : 0);
        _inputSequenceStack.last.add(carbonCount);

        _checkDone();
      }
    });
  }

  void _getRadical() {
    RadicalGeneratorPopup(onSubmitted: _bondRadical).show(context);
  }

  void _bondFunction(FunctionalGroup function) {
    _startEditing();

    setState(() {
      int code =
          _openChainStack.last.getOrderedBondableGroups().indexOf(function);

      if (code != -1) {
        if (function != FunctionalGroup.ether) {
          _openChainStack.last.bondFunctionalGroup(function);
          _checkDone();
        } else {
          _openChainStack.last = Ether(_openChainStack.last as Simple);
        }

        _inputSequenceStack.last.add(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<FunctionalGroup, FunctionalGroupButton> functionToButton = {
      FunctionalGroup.hydrogen: FunctionalGroupButton(
        bonds: 1,
        text: 'H',
        actionText: 'Hidrógeno',
        onPressed: () => _bondFunction(FunctionalGroup.hydrogen),
      ),
      FunctionalGroup.radical: FunctionalGroupButton(
        bonds: 1,
        text: 'CH2 –– CH3',
        actionText: 'Radical',
        onPressed: _getRadical,
      ),
      FunctionalGroup.iodine: FunctionalGroupButton(
        bonds: 1,
        text: 'I',
        actionText: 'Yodo',
        onPressed: () => _bondFunction(FunctionalGroup.iodine),
      ),
      FunctionalGroup.fluorine: FunctionalGroupButton(
        bonds: 1,
        text: 'F',
        actionText: 'Flúor',
        onPressed: () => _bondFunction(FunctionalGroup.fluorine),
      ),
      FunctionalGroup.chlorine: FunctionalGroupButton(
        bonds: 1,
        text: 'Cl',
        actionText: 'Cloro',
        onPressed: () => _bondFunction(FunctionalGroup.chlorine),
      ),
      FunctionalGroup.bromine: FunctionalGroupButton(
        bonds: 1,
        text: 'Br',
        actionText: 'Bromo',
        onPressed: () => _bondFunction(FunctionalGroup.bromine),
      ),
      FunctionalGroup.nitro: FunctionalGroupButton(
        bonds: 1,
        text: 'NO2',
        actionText: 'Nitro',
        onPressed: () => _bondFunction(FunctionalGroup.nitro),
      ),
      FunctionalGroup.ether: FunctionalGroupButton(
        bonds: 1,
        text: 'O',
        actionText: 'Éter',
        onPressed: () => _bondFunction(FunctionalGroup.ether),
      ),
      FunctionalGroup.amine: FunctionalGroupButton(
        bonds: 1,
        text: 'NH2',
        actionText: 'Amina',
        onPressed: () => _bondFunction(FunctionalGroup.amine),
      ),
      FunctionalGroup.alcohol: FunctionalGroupButton(
        bonds: 1,
        text: 'OH',
        actionText: 'Alcohol',
        onPressed: () => _bondFunction(FunctionalGroup.alcohol),
      ),
      FunctionalGroup.ketone: FunctionalGroupButton(
        bonds: 2,
        text: 'O',
        actionText: 'Cetona',
        onPressed: () => _bondFunction(FunctionalGroup.ketone),
      ),
      FunctionalGroup.aldehyde: FunctionalGroupButton(
        bonds: 3,
        text: 'HO',
        actionText: 'Aldehído',
        onPressed: () => _bondFunction(FunctionalGroup.aldehyde),
      ),
      FunctionalGroup.nitrile: FunctionalGroupButton(
        bonds: 3,
        text: 'N',
        actionText: 'Nitrilo',
        onPressed: () => _bondFunction(FunctionalGroup.nitrile),
      ),
      FunctionalGroup.amide: FunctionalGroupButton(
        bonds: 3,
        text: 'ONH2',
        actionText: 'Amida',
        onPressed: () => _bondFunction(FunctionalGroup.amide),
      ),
      FunctionalGroup.acid: FunctionalGroupButton(
        bonds: 3,
        text: 'OOH',
        actionText: 'Ácido',
        onPressed: () => _bondFunction(FunctionalGroup.acid),
      ),
    };

    return QuimifyScaffold(
      header: const QuimifyPageBar(title: _title),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              // So it follows while typing:
              reverse: true,
              // To remove Text widget default top padding:
              padding: const EdgeInsets.only(top: 13, bottom: 17),
              child: Row(children: [
                const SizedBox(width: 25),
                Text(
                  formatStructure(_openChainStack.last.getStructure()),
                  style: const TextStyle(
                    color: quimifyTeal,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  strutStyle: const StrutStyle(fontSize: 28, height: 1.4),
                ),
                const SizedBox(width: 25),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 25),
              Expanded(
                child: QuimifyButton(
                  height: 40,
                  color: quimifyTeal,
                  onPressed: _bondCarbon,
                  enabled: _canBondCarbon(),
                  child: Image.asset(
                    'assets/images/icons/bond-carbon.png',
                    color: Theme.of(context).colorScheme.surface,
                    width: 26,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: QuimifyButton(
                  height: 40,
                  color: const Color.fromARGB(255, 56, 133, 224),
                  onPressed: _hydrogenate,
                  enabled: _canHydrogenate(),
                  child: Image.asset(
                    'assets/images/icons/hydrogenate.png',
                    color: Theme.of(context).colorScheme.surface,
                    width: 28,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: QuimifyButton(
                  height: 40,
                  color: const Color.fromARGB(255, 255, 96, 96),
                  onPressed: _undo,
                  enabled: _canUndo(),
                  child: Icon(
                    Icons.undo,
                    size: 22,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
              const SizedBox(width: 25),
            ],
          ),
          if (_done) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: QuimifyButton.gradient(
                height: 50,
                gradient: quimifyGradient,
                onPressed: _pressedButton,
                child: const Text(
                  'Resolver',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
          if (!_done) ...[
            const SizedBox(height: 25),
            const QuimifySectionTitle.custom(
              title: 'Sustituyentes',
              horizontalPadding: 25,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            Container(
              margin: const EdgeInsets.all(25),
              height: 1.5,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 10), // +15=20
                children: _openChainStack.last
                    .getOrderedBondableGroups()
                    .map((function) => functionToButton[function]!)
                    .toList()
                    .reversed
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class FunctionalGroupButton extends StatelessWidget {
  const FunctionalGroupButton(
      {Key? key,
      required this.bonds,
      required this.text,
      required this.actionText,
      required this.onPressed})
      : super(key: key);

  final int bonds;
  final String text, actionText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 25, right: 25),
      child: QuimifyButton(
        height: 60,
        onPressed: onPressed,
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          children: [
            const SizedBox(width: 10),
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                bonds == 1
                    ? 'assets/images/icons/single-bond.png'
                    : bonds == 2
                        ? 'assets/images/icons/double-bond.png'
                        : 'assets/images/icons/triple-bond.png',
                color: Theme.of(context).colorScheme.primary,
                width: 30,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              formatStructureInput(text),
              style: const TextStyle(
                letterSpacing: 1,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              actionText,
              style: const TextStyle(
                color: quimifyTeal,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.add,
              color: quimifyTeal,
              size: 22,
            ),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
}

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
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
