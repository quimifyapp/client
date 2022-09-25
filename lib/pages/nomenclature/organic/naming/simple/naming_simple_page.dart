import 'package:auto_size_text/auto_size_text.dart';
import 'package:cliente/organic/components/functions.dart';
import 'package:cliente/organic/components/substituent.dart';
import 'package:cliente/pages/nomenclature/organic/naming/widgets/function_button.dart';
import 'package:cliente/utils/text.dart';
import 'package:cliente/widgets/section_title.dart';
import 'package:flutter/material.dart';

import '../../../../../api/api.dart';
import '../../../../../api/results/organic_result.dart';
import '../../../../../constants.dart';
import '../../../../../organic/types/simple.dart';
import '../../../../../utils/loading.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/dialog_popup.dart';
import '../../../../../widgets/page_app_bar.dart';
import '../result_page.dart';

class NamingSimplePage extends StatefulWidget {
  const NamingSimplePage({Key? key}) : super(key: key);

  @override
  State<NamingSimplePage> createState() => _NamingSimplePageState();
}

class _NamingSimplePageState extends State<NamingSimplePage> {
  final String _title = 'Nombrar simple';

  late List<Simple> _simpleStack;
  late List<List<int>> _sequenceStack;

  late bool _done;

  final double _unselectedOpacity = 0.5;

  void _reset() {
    _simpleStack = [Simple()];
    _simpleStack[0].bondCarbon();
    _sequenceStack = [[]];
    _done = false;
  }

  @override
  void initState() {
    _reset();
    super.initState();
  }

  Future<OrganicResult?> _search() async {
    startLoading(context);

    OrganicResult? result = await Api().getSimple(_sequenceStack.last);

    stopLoading();

    if (result != null) {
      if (!result.present) {
        if (!mounted) return null; // For security reasons
        const DialogPopup.message(
          title: 'Sin resultado',
        ).show(context);
      }
    } else {
      // Client already reported an error in this case
      if (!mounted) return null; // For security reasons
      const DialogPopup.message(
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
              MaterialPageRoute(builder: (BuildContext context) {
                return ResultPage(
                  title: _title,
                  result: organicResult,
                );
              }),
            );
          }
        },
      );
    }
  }

  void _checkDone() {
    setState(() => _done = _simpleStack.last.isDone());
  }

  void _startEditing() {
    _simpleStack.add(Simple.from(_simpleStack.last));
    _sequenceStack.add(List.from(_sequenceStack.last));
  }

  bool _canBondCarbon() => [1, 2, 3].contains(_simpleStack.last.getFreeBonds());

  void _bondCarbon() {
    if (_canBondCarbon()) {
      _startEditing();
      setState(() {
        _simpleStack.last.bondCarbon();
        _sequenceStack.last.add(-1);
        _checkDone();
      });
    }
  }

  bool _canHydrogenate() => _simpleStack.last.getFreeBonds() > 0;

  void _hydrogenate() {
    if (_canHydrogenate()) {
      _startEditing();
      setState(() {
        int limit = _simpleStack.last.getFreeBonds() > 1 ? 1 : 0;
        while (_simpleStack.last.getFreeBonds() > limit) {
          int code = _simpleStack.last
              .getAvailableSubstituents()
              .indexOf(Functions.hydrogen);
          if (code != -1) {
            _simpleStack.last.bondFunction(Functions.hydrogen);
            _sequenceStack.last.add(code);
            _checkDone();
          }
        }
      });
    }
  }

  bool _canUndo() => _simpleStack.length > 1;

  void _undo() {
    if (_canUndo()) {
      setState(() {
        _simpleStack.removeLast();
        _sequenceStack.removeLast();
        _checkDone();
      });
    }
  }

  void _bondRadical() {}

  void _bondFunction(Functions function) {
    _startEditing();
    setState(() {
      int code = _simpleStack.last.getAvailableSubstituents().indexOf(function);
      if (code != -1) {
        _simpleStack.last.bondFunction(function);
        _sequenceStack.last.add(code);
        _checkDone();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<Functions, FunctionButton> functionToButton = {
      Functions.acid: FunctionButton(
        bonds: 3,
        text: 'OOH',
        onPressed: () => _bondFunction(Functions.acid),
      ),
      Functions.amide: FunctionButton(
        bonds: 3,
        text: 'ONH2',
        onPressed: () => _bondFunction(Functions.amide),
      ),
      Functions.nitrile: FunctionButton(
        bonds: 3,
        text: 'N',
        onPressed: () => _bondFunction(Functions.nitrile),
      ),
      Functions.aldehyde: FunctionButton(
        bonds: 3,
        text: 'HO',
        onPressed: () => _bondFunction(Functions.aldehyde),
      ),
      Functions.ketone: FunctionButton(
        bonds: 2,
        text: 'O',
        onPressed: () => _bondFunction(Functions.ketone),
      ),
      Functions.alcohol: FunctionButton(
        bonds: 1,
        text: 'OH',
        onPressed: () => _bondFunction(Functions.alcohol),
      ),
      Functions.amine: FunctionButton(
        bonds: 1,
        text: 'NH2',
        onPressed: () => _bondFunction(Functions.amine),
      ),
      Functions.nitro: FunctionButton(
        bonds: 1,
        text: 'NO2',
        onPressed: () => _bondFunction(Functions.nitro),
      ),
      Functions.bromine: FunctionButton(
        bonds: 1,
        text: 'Br',
        onPressed: () => _bondFunction(Functions.bromine),
      ),
      Functions.chlorine: FunctionButton(
        bonds: 1,
        text: 'Cl',
        onPressed: () => _bondFunction(Functions.chlorine),
      ),
      Functions.fluorine: FunctionButton(
        bonds: 1,
        text: 'F',
        onPressed: () => _bondFunction(Functions.fluorine),
      ),
      Functions.iodine: FunctionButton(
        bonds: 1,
        text: 'I',
        onPressed: () => _bondFunction(Functions.iodine),
      ),
      Functions.radical: FunctionButton(
        bonds: 1,
        text: 'CH2 ... CH3',
        onPressed: () => _bondRadical(),
      ),
      Functions.hydrogen: FunctionButton(
        bonds: 1,
        text: 'H',
        onPressed: () => _bondFunction(Functions.hydrogen),
      ),
    };

    return Container(
      decoration: quimifyGradientBoxDecoration,
      child: Scaffold(
        // To avoid keyboard resizing:
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            PageAppBar(title: _title),
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
                    Container(
                      margin:
                          const EdgeInsets.only(top: 25, left: 25, right: 25),
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                        left: 25,
                        right: 25,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        maxLines: 4,
                        stepGranularity: 0.1,
                        minFontSize: 14,
                        formatOrganicFormula(_simpleStack.last.toString()),
                        style: const TextStyle(
                          color: quimifyTeal,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 25),
                        Expanded(
                          child: Button(
                            height: 40,
                            color: quimifyTeal.withOpacity(
                                _canBondCarbon() ? 1 : _unselectedOpacity),
                            onPressed: _bondCarbon,
                            enabled: _canBondCarbon(),
                            child: Image.asset(
                              'assets/images/icons/bond_carbon.png',
                              color: Theme.of(context).colorScheme.surface,
                              width: 26,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Button(
                            height: 40,
                            color: const Color.fromARGB(255, 56, 133, 224)
                                .withOpacity(
                                    _canHydrogenate() ? 1 : _unselectedOpacity),
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
                          child: Button(
                            height: 40,
                            color: const Color.fromARGB(255, 255, 96, 96)
                                .withOpacity(
                                    _canUndo() ? 1 : _unselectedOpacity),
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
                    if (!_done) ...[
                      const SizedBox(height: 25),
                      const SectionTitle.custom(
                        title: 'Sustituyentes',
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
                          padding: EdgeInsets.zero,
                          children: _simpleStack.last
                              .getAvailableSubstituents()
                              .map((function) => functionToButton[function]!)
                              .toList()
                              .reversed
                              .toList(),
                        ),
                      ),
                    ],
                    if (_done) ...[
                      const SizedBox(height: 25),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Button.gradient(
                          height: 50,
                          gradient: quimifyGradient,
                          onPressed: _pressedButton,
                          child: const Text(
                            'Nombrar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
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
