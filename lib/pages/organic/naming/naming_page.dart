import 'package:quimify_client/api/api.dart';
import 'package:quimify_client/api/results/organic_result.dart';
import 'package:quimify_client/api/organic/components/group.dart';
import 'package:quimify_client/api/organic/components/substituent.dart';
import 'package:quimify_client/api/organic/molecules/open_chain/open_chain.dart';
import 'package:quimify_client/api/organic/molecules/open_chain/simple.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/add_carbon_button.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/group_button.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/hydrogenate_button.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/undo_button.dart';
import 'package:quimify_client/pages/organic/naming/widgets/naming_help_dialog.dart';
import 'package:quimify_client/pages/organic/naming/widgets/radical_factory/radical_factory_dialog.dart';
import 'package:quimify_client/pages/organic/naming/organic_result_page.dart';
import 'package:quimify_client/pages/organic/widgets/organic_result_view.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_gradient.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_message_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_no_internet_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_report_dialog.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/utils/internet.dart';
import 'package:quimify_client/utils/text.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_loading.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:flutter/material.dart';

class NamingPage extends StatefulWidget {
  const NamingPage({Key? key}) : super(key: key);

  @override
  State<NamingPage> createState() => _NamingPageState();
}

class _NamingPageState extends State<NamingPage> {
  static const String _title = 'Nombrar orgánicos';

  late bool _done;
  late List<OpenChain> _openChainStack;
  late List<List<int>> _sequenceStack;

  @override
  void initState() {
    super.initState();

    _reset();
  }

  void _reset() {
    _openChainStack = [Simple()];
    _sequenceStack = [[]];
    _done = false;
  }

  OpenChain _openChain() => _openChainStack.last;

  List<int> _sequence() => _sequenceStack.last;

  Future<OrganicResult?> _search() async {
    startQuimifyLoading(context);

    OrganicResult? result = await Api().getOrganicFromStructure(_sequence());

    stopQuimifyLoading();

    if (result != null) {
      if (!result.present) {
        if (!mounted) return null; // For security reasons
        const QuimifyMessageDialog(title: 'Sin resultado').showIn(context);

        return null;
      }
    } else {
      // Client already reported an error in this case
      if (!mounted) return null; // For security reasons
      checkInternetConnection().then(
        (bool hasInternetConnection) {
          if (hasInternetConnection) {
            const QuimifyMessageDialog(
              title: 'Sin resultado',
            ).showIn(context);
          } else {
            quimifyNoInternetDialog.showIn(context);
          }
        },
      );
    }

    return result;
  }

  void _showResult(OrganicResult organicResult) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return OrganicResultPage(
            title: _title,
            organicResultView: OrganicResultView(
              fields: {
                if (organicResult.name != null) 'Nombre:': organicResult.name!,
                if (organicResult.molecularMass != null)
                  'Masa molecular:':
                      '${formatMolecularMass(organicResult.molecularMass!)}'
                          ' g/mol',
                if (organicResult.structure != null)
                  'Fórmula:': formatStructure(organicResult.structure!),
              },
              imageProvider: organicResult.url2D != null
                  ? NetworkImage(organicResult.url2D!)
                  : null,
              quimifyReportDialog: QuimifyReportDialog(
                details: 'Resultado de:\n"'
                    '${formatStructure(organicResult.structure!)}"',
                reportContext: 'Organic naming',
                reportDetails: 'Result of ${_sequence()}: $organicResult',
              ),
            ),
          );
        },
      ),
    );
  }

  void _pressedButton() {
    if (_done) {
      _search().then((organicResult) {
        if (organicResult != null) {
          _showResult(organicResult);
        }
      });
    }
  }

  // Editing panel:

  void _checkDone() => setState(() => _done = _openChain().isDone());

  void _startEditing() {
    _openChainStack.add(_openChain().getCopy());
    _sequenceStack.add(List.from(_sequence()));
  }

  bool _canUndo() => _openChainStack.length > 1;

  void _undoButton() {
    if (_canUndo()) {
      setState(() {
        _openChainStack.removeLast();
        _sequenceStack.removeLast();
        _checkDone();
      });
    } else {
      const QuimifyMessageDialog(
        title: 'Nada que deshacer',
        details: 'Prueba a enlazar un sustiuyente.',
      ).showIn(context);
    }
  }

  bool _canBondCarbon() => _openChain().canBondCarbon();

  void _pressedBondCarbonButton() {
    if (_canBondCarbon()) {
      _startEditing();
      setState(() {
        _openChain().bondCarbon();
        _sequence().add(-1);
        _checkDone();
      });
    } else if (_openChain().getFreeBondCount() == 4) {
      const QuimifyMessageDialog(
        title: 'Faltan sustituyentes',
        details: 'Este carbono tiene cuatro enlaces libres, pero dos carbonos '
            'pueden compartir un maximo de tres.\n\n'
            'Prueba a enlazar un sustiuyente.',
      ).showIn(context);
    } else {
      const QuimifyMessageDialog(
        title: 'No hace falta',
        details: 'Se enlazará otro carbono al oxígeno cuando completes este '
            'carbono.',
      ).showIn(context);
    }
  }

  void _pressedHydrogenateButton() {
    do {
      _pressedGroupButton(Group.hydrogen);
    } while (_openChain().getFreeBondCount() > 1);
  }

  void _pressedResetButton() => setState(() => _reset());

  // Below editing panel:

  void _pressedRadicalButton() =>
      RadicalFactoryDialog(onSubmitted: _bondRadical).show(context);

  void _bondRadical(int carbonCount, bool isIso) {
    _startEditing();

    if (!_openChain().getBondableGroups().contains(Group.radical)) {
      return;
    }

    setState(() {
      _openChain().bondSubstituent(Substituent.radical(carbonCount, isIso));

      _sequence().add(Group.radical.index);
      _sequence().add(isIso ? 1 : 0);
      _sequence().add(carbonCount);

      _checkDone();
    });
  }

  void _pressedGroupButton(Group group) {
    _startEditing();

    if (!_openChain().getBondableGroups().contains(group)) {
      return;
    }

    setState(() {
      _openChainStack.last = _openChain().bondGroup(group);
      _sequence().add(group.index);
      _checkDone();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<Group, GroupButton> groupToButton = {
      Group.hydrogen: GroupButton(
        bonds: 1,
        structure: 'H',
        name: 'Hidrógeno',
        onPressed: () => _pressedGroupButton(Group.hydrogen),
      ),
      Group.radical: GroupButton(
        bonds: 1,
        structure: 'CH2 – CH3',
        name: 'Radical',
        onPressed: _pressedRadicalButton,
      ),
      Group.iodine: GroupButton(
        bonds: 1,
        structure: 'I',
        name: 'Yodo',
        onPressed: () => _pressedGroupButton(Group.iodine),
      ),
      Group.fluorine: GroupButton(
        bonds: 1,
        structure: 'F',
        name: 'Flúor',
        onPressed: () => _pressedGroupButton(Group.fluorine),
      ),
      Group.chlorine: GroupButton(
        bonds: 1,
        structure: 'Cl',
        name: 'Cloro',
        onPressed: () => _pressedGroupButton(Group.chlorine),
      ),
      Group.bromine: GroupButton(
        bonds: 1,
        structure: 'Br',
        name: 'Bromo',
        onPressed: () => _pressedGroupButton(Group.bromine),
      ),
      Group.nitro: GroupButton(
        bonds: 1,
        structure: 'NO2',
        name: 'Nitro',
        onPressed: () => _pressedGroupButton(Group.nitro),
      ),
      Group.ether: GroupButton(
        bonds: 1,
        structure: 'O',
        name: 'Éter',
        onPressed: () => _pressedGroupButton(Group.ether),
      ),
      Group.amine: GroupButton(
        bonds: 1,
        structure: 'NH2',
        name: 'Amina',
        onPressed: () => _pressedGroupButton(Group.amine),
      ),
      Group.alcohol: GroupButton(
        bonds: 1,
        structure: 'OH',
        name: 'Alcohol',
        onPressed: () => _pressedGroupButton(Group.alcohol),
      ),
      Group.ketone: GroupButton(
        bonds: 2,
        structure: 'O',
        name: 'Cetona',
        onPressed: () => _pressedGroupButton(Group.ketone),
      ),
      Group.aldehyde: GroupButton(
        bonds: 3,
        structure: 'HO',
        name: 'Aldehído',
        onPressed: () => _pressedGroupButton(Group.aldehyde),
      ),
      Group.nitrile: GroupButton(
        bonds: 3,
        structure: 'N',
        name: 'Nitrilo',
        onPressed: () => _pressedGroupButton(Group.nitrile),
      ),
      Group.amide: GroupButton(
        bonds: 3,
        structure: 'ONH2',
        name: 'Amida',
        onPressed: () => _pressedGroupButton(Group.amide),
      ),
      Group.acid: GroupButton(
        bonds: 3,
        structure: 'OOH',
        name: 'Ácido',
        onPressed: () => _pressedGroupButton(Group.acid),
      ),
    };

    return WillPopScope(
      onWillPop: () async {
        stopQuimifyLoading();
        return true;
      },
      child: QuimifyScaffold(
        header: const QuimifyPageBar(title: _title),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              // Input display:
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true, // So it follows while typing
                  // To remove Text widget's default top padding:
                  padding: const EdgeInsets.only(
                    top: 15 - 2,
                    bottom: 15 + 2,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 25),
                      Text(
                        formatStructure(_openChain().getStructure()),
                        style: const TextStyle(
                          fontFamily: 'CeraProBoldCustom',
                          fontSize: 28,
                          color: quimifyTeal,
                        ),
                        strutStyle: const StrutStyle(
                          fontSize: 28,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(width: 25),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Buttons:
              Row(
                children: [
                  Expanded(
                    child: UndoButton(
                      onPressed: _undoButton,
                      enabled: _canUndo(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (!_done) ...[
                    Expanded(
                      child: AddCarbonButton(
                        enabled: _canBondCarbon(),
                        onPressed: _pressedBondCarbonButton,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: HydrogenateButton(
                        onPressed: _pressedHydrogenateButton,
                        enabled: true,
                      ),
                    ),
                  ],
                  if (_done) ...[
                    // Reset button:
                    Expanded(
                      child: QuimifyButton(
                        height: 40,
                        onPressed: _pressedResetButton,
                        color: const Color.fromARGB(255, 56, 133, 224),
                        child: Icon(
                          Icons.delete_rounded,
                          size: 22,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // 'Solve it' button:
                    Expanded(
                      child: QuimifyButton.gradient(
                        height: 40,
                        onPressed: _pressedButton,
                        gradient: quimifyGradient,
                        child: Text(
                          'Resolver',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),
              // Substituents:
              if (!_done) ...[
                const QuimifySectionTitle(
                  title: 'Sustituyentes',
                  helpDialog: NamingHelpDialog(),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // To avoid rounded corners overflow:
                    clipBehavior: Clip.hardEdge,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 5, // + 15 from above SizedBox = 20
                          bottom: 20, // Bottom padding of the page
                        ),
                        child: Wrap(
                          runSpacing: 15,
                          children: _openChain()
                              .getBondableGroups()
                              .map((function) => groupToButton[function]!)
                              .toList()
                              .reversed
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
