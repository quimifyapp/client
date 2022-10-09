import 'package:quimify_client/api/api.dart';
import 'package:quimify_client/api/results/organic_result.dart';
import 'package:quimify_client/organic/components/functional_group.dart';
import 'package:quimify_client/organic/components/substituent.dart';
import 'package:quimify_client/organic/compounds/open_chain/ether.dart';
import 'package:quimify_client/organic/compounds/open_chain/open_chain.dart';
import 'package:quimify_client/organic/compounds/open_chain/simple.dart';
import 'package:quimify_client/pages/nomenclature/organic/naming/open_chain/widgets/functional_group_button.dart';
import 'package:quimify_client/pages/nomenclature/organic/naming/open_chain/widgets/radical_factory_dialog.dart';
import 'package:quimify_client/pages/nomenclature/organic/naming/organic_result_page.dart';
import 'package:quimify_client/pages/nomenclature/organic/widgets/organic_result_view.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_gradient.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_message_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_report_dialog.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/utils/text.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_loading.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:flutter/material.dart';

class NamingOpenChainPage extends StatefulWidget {
  const NamingOpenChainPage({Key? key}) : super(key: key);

  @override
  State<NamingOpenChainPage> createState() => _NamingOpenChainPageState();
}

class _NamingOpenChainPageState extends State<NamingOpenChainPage> {
  static const String _title = 'Nombrar cadena abierta';

  late List<OpenChain> _openChainStack;
  late List<List<int>> _sequenceStack;
  late bool _done;

  void _reset() {
    _openChainStack = [Simple()];
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

    OrganicResult? result = await Api().getOrganic(_sequenceStack.last);

    stopLoading();

    if (result != null) {
      if (!result.present) {
        if (!mounted) return null; // For security reasons
        const QuimifyMessageDialog(title: 'Sin resultado').show(context);

        return null;
      }
    } else {
      // Client already reported an error in this case
      if (!mounted) return null; // For security reasons
      const QuimifyMessageDialog(title: 'Sin resultado').show(context);
    }

    return result;
  }

  void _pressedButton() {
    if (_done) {
      _search().then(
        (organicResult) {
          if (organicResult != null) {
            String sequence = _sequenceStack.last.toString();

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return OrganicResultPage(
                    title: _title,
                    organicResultView: OrganicResultView(
                      fields: {
                        if (organicResult.name != null)
                          'Nombre:': organicResult.name!,
                        if (organicResult.mass != null)
                          'Masa molecular:': '${organicResult.mass!} g/mol',
                        if (organicResult.structure != null)
                          'Fórmula:': formatStructure(organicResult.structure!),
                      },
                      imageProvider: organicResult.url2D != null
                          ? NetworkImage(organicResult.url2D!)
                          : null,
                      quimifyReportDialog: QuimifyReportDialog(
                        reportLabel: 'Cadena abierta, búsqueda de $sequence',
                        details: 'Resultado:\n"${organicResult.name!}"',
                      ),
                    ),
                  );
                },
              ),
            );
          }

          setState(_reset);
        },
      );
    }
  }

  void _checkDone() => setState(() => _done = _openChainStack.last.isDone());

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
              .getOrderedBondableGroups()
              .indexOf(FunctionalGroup.hydrogen);
          if (code != -1) {
            _openChainStack.last.bondFunctionalGroup(FunctionalGroup.hydrogen);
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

  void _bondRadical(int carbonCount, bool isIso) {
    _startEditing();

    setState(() {
      int code = _openChainStack.last
          .getOrderedBondableGroups()
          .indexOf(FunctionalGroup.radical);

      if (code != -1) {
        _openChainStack.last
            .bondSubstituent(Substituent.radical(carbonCount, isIso));

        _sequenceStack.last.add(code);
        _sequenceStack.last.add(isIso ? 1 : 0);
        _sequenceStack.last.add(carbonCount);

        _checkDone();
      }
    });
  }

  void _getRadical() =>
      RadicalFactoryDialog(onSubmitted: _bondRadical).show(context);

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

        _sequenceStack.last.add(code);
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
              child: Row(
                children: [
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 25),
              Expanded(
                child: QuimifyButton(
                  height: 40,
                  backgroundColor: quimifyTeal,
                  onPressed: _bondCarbon,
                  enabled: _canBondCarbon(),
                  child: Image.asset(
                    'assets/images/icons/bond-carbon.png',
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: 26,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: QuimifyButton(
                  height: 40,
                  backgroundColor: const Color.fromARGB(255, 56, 133, 224),
                  onPressed: _hydrogenate,
                  enabled: _canHydrogenate(),
                  child: Image.asset(
                    'assets/images/icons/hydrogenate.png',
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: 28,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: QuimifyButton(
                  height: 40,
                  backgroundColor: const Color.fromARGB(255, 255, 96, 96),
                  onPressed: _undo,
                  enabled: _canUndo(),
                  child: Icon(
                    Icons.undo,
                    size: 22,
                    color: Theme.of(context).colorScheme.onPrimary,
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
                child: Text(
                  'Resolver',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
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
