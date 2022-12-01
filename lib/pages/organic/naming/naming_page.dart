import 'package:quimify_client/api/api.dart';
import 'package:quimify_client/api/results/organic_result.dart';
import 'package:quimify_client/api/organic/components/functional_group.dart';
import 'package:quimify_client/api/organic/components/substituent.dart';
import 'package:quimify_client/api/organic/compounds/open_chain/ether.dart';
import 'package:quimify_client/api/organic/compounds/open_chain/open_chain.dart';
import 'package:quimify_client/api/organic/compounds/open_chain/simple.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/add_carbon_button.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/functional_group_button.dart';
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

  static const double _buttonCount = 3;
  static const double _horizontalPadding = 20;
  static const double _buttonSeparatorWidth = 10;

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
    startQuimifyLoading(context);

    OrganicResult? result =
        await Api().getOrganicFromStructure(_sequenceStack.last);

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

  void _pressedButton() {
    if (_done) {
      _search().then(
        (organicResult) {
          if (organicResult != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return OrganicResultPage(
                    title: _title,
                    organicResultView: OrganicResultView(
                      fields: {
                        if (organicResult.name != null)
                          'Nombre:': organicResult.name!,
                        if (organicResult.molecularMass != null)
                          'Masa molecular:':
                              '${formatMolecularMass(organicResult.molecularMass!)} g/mol',
                        if (organicResult.structure != null)
                          'Fórmula:': formatStructure(organicResult.structure!),
                      },
                      imageProvider: organicResult.url2D != null
                          ? NetworkImage(organicResult.url2D!)
                          : null,
                      quimifyReportDialog: QuimifyReportDialog(
                        details: 'Resultado de:\n"'
                            '${formatStructure(organicResult.structure!)}"',
                        label: 'Cadena abierta, resultado de '
                            '${_sequenceStack.last.toString()}',
                      ),
                    ),
                  );
                },
              ),
            ).then(
              (_) => setState(_reset),
            );
          }
        },
      );
    }
  }

  void _checkDone() => setState(() => _done = _openChainStack.last.isDone());

  void _startEditing() {
    _openChainStack.add(_openChainStack.last.getCopy());
    _sequenceStack.add(List.from(_sequenceStack.last));
  }

  bool _canBondCarbon() => _openChainStack.last.canBondCarbon();

  void _bondCarbon() {
    if (_canBondCarbon()) {
      _startEditing();
      setState(() {
        _openChainStack.last.bondCarbon();
        _sequenceStack.last.add(-1);
        _checkDone();
      });
    } else if (_openChainStack.last.getFreeBonds() == 4) {
      const QuimifyMessageDialog(
        title: 'Faltan sustituyentes',
        details: 'Este carbono tiene cuatro enlaces libres, pero dos carbonos '
            'pueden compartir un maximo de tres.\n\n'
            'Prueba a enlazar un sustiuyente primero.',
      ).showIn(context);
    } else if (_openChainStack.last.getFreeBonds() == 0) {
      const QuimifyMessageDialog(
        title: 'Cadena completa',
        details: 'Para enlazar un carbono es necesario compartir al menos un '
            'enlace de los cuatro que tiene cada carbono.\n\n'
            'Prueba a deshacer el último cambio.',
      ).showIn(context);
    } else {}
  }

  bool _canHydrogenate() => _openChainStack.last.getFreeBonds() > 0;

  void _hydrogenate() {
    if (_canHydrogenate()) {
      _startEditing();
      setState(() {
        int amount = _openChainStack.last.getFreeBonds() > 1 ? 1 : 0;

        for (int i = _openChainStack.last.getFreeBonds(); i > amount; i--) {
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
    } else {
      const QuimifyMessageDialog(
        title: 'Cadena completa',
        details: 'Para enlazar un hidrógeno más es necesario compartir un '
            'enlace, pero este carbono ya ha utilizado sus cuatro.\n\n'
            'Prueba a deshacer el último cambio.',
      ).showIn(context);
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
        _openChainStack.last.bondFunctionalGroup(function);

        if (function == FunctionalGroup.ether) {
          _openChainStack.last = Ether(_openChainStack.last as Simple);
        } else {
          _checkDone();
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
        text: 'CH2 – CH3',
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

    double buttonWidth = MediaQuery.of(context).size.width; // Screen width
    buttonWidth -= (_buttonCount - 1) * _buttonSeparatorWidth; // Without breaks
    buttonWidth -= 2 * _horizontalPadding; // Without horizontal padding
    buttonWidth /= _buttonCount; // Per button

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
            left: _horizontalPadding,
            right: _horizontalPadding,
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
                        formatStructure(_openChainStack.last.getStructure()),
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
                  UndoButton(
                    width: buttonWidth,
                    onPressed: _undo,
                    enabled: _canUndo(),
                  ),
                  const SizedBox(width: _buttonSeparatorWidth),
                  if (!_done) ...[
                    AddCarbonButton(
                      width: buttonWidth,
                      enabled: _canBondCarbon(),
                      onPressed: _bondCarbon,
                    ),
                    const SizedBox(width: _buttonSeparatorWidth),
                    HydrogenateButton(
                      width: buttonWidth,
                      onPressed: _hydrogenate,
                      enabled: _canHydrogenate(),
                    ),
                  ],
                  if (_done) // 'Solve it' button
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
              ),
              const SizedBox(height: 20),
              // Substituents:
              if (!_done) ...[
                QuimifySectionTitle(
                  title: 'Sustituyentes',
                  dialog: NamingHelpDialog(
                    buttonWidth: buttonWidth,
                  ),
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
                          children: _openChainStack.last
                              .getOrderedBondableGroups()
                              .map((function) => functionToButton[function]!)
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
