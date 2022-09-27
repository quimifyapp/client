import 'package:auto_size_text/auto_size_text.dart';
import 'package:cliente/api/results/organic_result.dart';
import 'package:cliente/constants.dart';
import 'package:cliente/organic/components/functions.dart';
import 'package:cliente/organic/types/open_chain.dart';
import 'package:cliente/pages/nomenclature/organic/naming/open_chain/widget/function_button.dart';
import 'package:cliente/pages/nomenclature/organic/naming/organic_result_page.dart';
import 'package:cliente/utils/text.dart';
import 'package:cliente/widgets/button.dart';
import 'package:cliente/widgets/dialog_popup.dart';
import 'package:cliente/widgets/loading.dart';
import 'package:cliente/widgets/section_title.dart';
import 'package:flutter/material.dart';

class OpenChainBuilder extends StatefulWidget {
  const OpenChainBuilder({
    Key? key,
    required this.title,
    required this.openChain,
    required this.apiGetter,
  }) : super(key: key);

  final String title;
  final OpenChain openChain;
  final Future<OrganicResult?> Function(List<int>) apiGetter;

  @override
  State<OpenChainBuilder> createState() => _OpenChainBuilderState();
}

class _OpenChainBuilderState extends State<OpenChainBuilder> {
  final double _unselectedOpacity = 0.5;

  late bool _done;
  late List<OpenChain> _openChainStack;
  late List<List<int>> _sequenceStack;

  void _reset() {
    _openChainStack = [widget.openChain.getCopy()];
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

    OrganicResult? result = await widget.apiGetter(_sequenceStack.last);

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
                return OrganicResultPage(
                  title: widget.title,
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
    setState(() => _done = _openChainStack.last.isDone());
  }

  void _startEditing() {
    _openChainStack.add(_openChainStack.last.getCopy());
    _sequenceStack.add(List.from(_sequenceStack.last));
  }

  bool _canBondCarbon() =>
      [1, 2, 3].contains(_openChainStack.last.getFreeBonds());

  void _bondCarbon() {
    if (_canBondCarbon()) {
      _startEditing();
      setState(() {
        _openChainStack.last.bondCarbon();
        _sequenceStack.last.add(-1);
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
              .getBondableFunctions()
              .indexOf(Functions.hydrogen);
          if (code != -1) {
            _openChainStack.last.bondFunction(Functions.hydrogen);
            _sequenceStack.last.add(code);
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
        _sequenceStack.removeLast();
        _checkDone();
      });
    }
  }

  void _bondRadical() {}

  void _bondFunction(Functions function) {
    _startEditing();
    setState(() {
      int code =
          _openChainStack.last.getBondableFunctions().indexOf(function);
      if (code != -1) {
        _openChainStack.last.bondFunction(function);
        _sequenceStack.last.add(code);
        _checkDone();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final Map<Functions, FunctionButton> functionToButton = {
      Functions.hydrogen: FunctionButton(
        bonds: 1,
        text: 'H',
        actionText: 'Hidrógeno',
        onPressed: () => _bondFunction(Functions.hydrogen),
      ),
      Functions.radical: FunctionButton(
        bonds: 1,
        text: 'CH2 ... CH3',
        actionText: 'Radical',
        onPressed: () => _bondRadical(),
      ),
      Functions.iodine: FunctionButton(
        bonds: 1,
        text: 'I',
        actionText: 'Yodo',
        onPressed: () => _bondFunction(Functions.iodine),
      ),
      Functions.fluorine: FunctionButton(
        bonds: 1,
        text: 'F',
        actionText: 'Flúor',
        onPressed: () => _bondFunction(Functions.fluorine),
      ),
      Functions.chlorine: FunctionButton(
        bonds: 1,
        text: 'Cl',
        actionText: 'Cloro',
        onPressed: () => _bondFunction(Functions.chlorine),
      ),
      Functions.bromine: FunctionButton(
        bonds: 1,
        text: 'Br',
        actionText: 'Bromo',
        onPressed: () => _bondFunction(Functions.bromine),
      ),
      Functions.nitro: FunctionButton(
        bonds: 1,
        text: 'NO2',
        actionText: 'Nitro',
        onPressed: () => _bondFunction(Functions.nitro),
      ),
      Functions.ether: FunctionButton(
        bonds: 1,
        text: 'O',
        actionText: 'Éter',
        onPressed: () => _bondFunction(Functions.ether),
      ),
      Functions.amine: FunctionButton(
        bonds: 1,
        text: 'NH2',
        actionText: 'Amina',
        onPressed: () => _bondFunction(Functions.amine),
      ),
      Functions.alcohol: FunctionButton(
        bonds: 1,
        text: 'OH',
        actionText: 'Alcohol',
        onPressed: () => _bondFunction(Functions.alcohol),
      ),
      Functions.ketone: FunctionButton(
        bonds: 2,
        text: 'O',
        actionText: 'Cetona',
        onPressed: () => _bondFunction(Functions.ketone),
      ),
      Functions.aldehyde: FunctionButton(
        bonds: 3,
        text: 'HO',
        actionText: 'Aldehído',
        onPressed: () => _bondFunction(Functions.aldehyde),
      ),
      Functions.nitrile: FunctionButton(
        bonds: 3,
        text: 'N',
        actionText: 'Nitrilo',
        onPressed: () => _bondFunction(Functions.nitrile),
      ),
      Functions.amide: FunctionButton(
        bonds: 3,
        text: 'ONH2',
        actionText: 'Amida',
        onPressed: () => _bondFunction(Functions.amide),
      ),
      Functions.acid: FunctionButton(
        bonds: 3,
        text: 'OOH',
        actionText: 'Ácido',
        onPressed: () => _bondFunction(Functions.acid),
      ),
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin:
          const EdgeInsets.only(top: 25, left: 25, right: 25),
          padding: const EdgeInsets.only(
            top: 12,
            bottom: 18,
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
            formatOrganicFormula(_openChainStack.last.getFormula()),
            style: const TextStyle(
              color: quimifyTeal,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            strutStyle: const StrutStyle(fontSize: 28, height: 1.4),
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
              children: _openChainStack.last
                  .getBondableFunctions()
                  .map((function) => functionToButton[function]!)
                  .toList()
                  .reversed
                  .toList(),
            ),
          ),
          const SizedBox(height: 5),
        ],
        if (_done) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Button.gradient(
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
      ],
    );
  }
}
