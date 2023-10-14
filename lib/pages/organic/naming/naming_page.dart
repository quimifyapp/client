import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/internet/api/api.dart';
import 'package:quimify_client/internet/api/organic/components/group.dart';
import 'package:quimify_client/internet/api/organic/components/substituent.dart';
import 'package:quimify_client/internet/api/organic/molecules/open_chain/open_chain.dart';
import 'package:quimify_client/internet/api/organic/molecules/open_chain/simple.dart';
import 'package:quimify_client/internet/api/results/organic_result.dart';
import 'package:quimify_client/local/history.dart';
import 'package:quimify_client/pages/history/history_entry.dart';
import 'package:quimify_client/pages/history/history_field.dart';
import 'package:quimify_client/pages/history/history_page.dart';
import 'package:quimify_client/pages/organic/naming/organic_result_page.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/add_carbon_button.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/group_button.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/hydrogenate_button.dart';
import 'package:quimify_client/pages/organic/naming/widgets/buttons/undo_button.dart';
import 'package:quimify_client/pages/organic/naming/widgets/naming_help_dialog.dart';
import 'package:quimify_client/pages/organic/naming/widgets/radical_factory/radical_factory_dialog.dart';
import 'package:quimify_client/pages/organic/widgets/organic_result_view.dart';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_loading.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_message_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/quimify_no_internet_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/report_dialog.dart';
import 'package:quimify_client/pages/widgets/objects/history_button.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/internet/connection.dart';
import 'package:quimify_client/text/text.dart';

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

  final ScrollController _scrollController = ScrollController();

  @override
  initState() {
    super.initState();

    _reset();
  }

  _reset() {
    _openChainStack = [Simple()];
    _sequenceStack = [[]];
    _done = false;
  }

  OpenChain _openChain() => _openChainStack.last;

  List<int> _sequence() => _sequenceStack.last;

  _search(List<int> sequence) async {
    startQuimifyLoading(context);

    Ads().showInterstitialAd(); // There will be a result most of the times

    OrganicResult? result = await Api().getOrganicFromStructure(sequence);

    if (result != null) {
      if (!result.present) {
        if (!mounted) return null; // For security reasons
        const QuimifyMessageDialog(title: 'Sin resultado').show(context);

        return null;
      }

      _showResult(result);

      History().saveOrganicName(result, sequence);
    } else {
      if (!mounted) return null; // For security reasons

      if (await hasInternetConnection()) {
        const QuimifyMessageDialog(
          title: 'Sin resultado',
        ).show(context);
      } else {
        quimifyNoInternetDialog.show(context);
      }
    }

    stopQuimifyLoading();

    return result;
  }

  _showResult(OrganicResult organicResult) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => OrganicResultPage(
          title: _title,
          organicResultView: OrganicResultView(
            fields: {
              if (organicResult.name != null) 'Nombre': organicResult.name!,
              if (organicResult.molecularMass != null)
                'Masa molecular':
                    '${formatMolecularMass(organicResult.molecularMass!)}'
                        ' g/mol',
              if (organicResult.structure != null)
                'Fórmula': formatStructure(organicResult.structure!),
            },
            imageProvider: organicResult.url2D != null
                ? NetworkImage(organicResult.url2D!)
                : null,
            onHistoryPressed: _showHistory,
            quimifyReportDialog: ReportDialog(
              details: 'Resultado de\n"'
                  '${formatStructure(organicResult.structure!)}"',
              reportContext: 'Organic naming',
              reportDetails: 'Result of ${_sequence()}: $organicResult',
            ),
          ),
        ),
      ),
    );
  }

  _showHistory(BuildContext? resultPageContext) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => HistoryPage(
          entries: History()
              .getOrganicNames()
              .map((e) => HistoryEntry(
                    query: e.sequence,
                    fields: [
                      HistoryField(
                        'Fórmula',
                        formatStructure(e.structure!),
                      ),
                      HistoryField(
                        'Nombre',
                        e.name,
                      ),
                    ],
                  ))
              .toList(),
          onEntryPressed: (sequence) {
            if (resultPageContext != null) {
              Navigator.of(resultPageContext).pop();
            }

            _search(sequence);
          },
        ),
      ),
    );
  }

  // Editing panel:

  _checkDone() => setState(() => _done = _openChain().isDone());

  _startEditing() {
    _openChainStack.add(_openChain().getCopy());
    _sequenceStack.add(List.from(_sequence()));
  }

  bool _canUndo() => _openChainStack.length > 1;

  _undoButton() {
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
      ).show(context);
    }
  }

  bool _canBondCarbon() => _openChain().canBondCarbon();

  bool _canHydrogenate() => !_done;

  _pressedBondCarbonButton() {
    if (_canBondCarbon()) {
      _startEditing();
      setState(() {
        _openChain().bondCarbon();
        _sequence().add(-1);
        _checkDone();
      });
    } else if (_openChain().getFreeBondCount() == 4) {
      const QuimifyMessageDialog(
        title: 'Molécula vacía',
        details: 'Todavía no es posible enlazar otro carbono. Prueba a enlazar '
            'un sustiuyente.',
      ).show(context);
    } else {
      const QuimifyMessageDialog(
        title: 'No hace falta',
        details: 'Se enlazará otro carbono al oxígeno cuando completes este '
            'carbono.',
      ).show(context);
    }
  }

  _pressedHydrogenateButton() {
    if (_canHydrogenate()) {
      do {
        _pressedGroupButton(Group.hydrogen);
      } while (_openChain().getFreeBondCount() > 1);
    } else {
      const QuimifyMessageDialog(
        title: 'Molécula completa',
        details: 'No quedan valencias libres para enlazar más hidrógenos.',
      ).show(context);
    }
  }

  _pressedResetButton() => setState(() => _reset());

  // Below editing panel:

  _pressedRadicalButton() =>
      RadicalFactoryDialog(onSubmitted: _bondRadical).show(context);

  _bondRadical(int carbonCount, bool isIso) {
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

  _pressedGroupButton(Group group) {
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
    const double buttonHeight = 40;

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

    if (_done) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }

    final Container doneDialog = Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            // TODO hide in small screens?
            'assets/images/completed.png',
            height: 150,
          ),
          const SizedBox(height: 20),
          AutoSizeText(
            '¡Enhorabuena!',
            maxLines: 1,
            stepGranularity: 0.1,
            maxFontSize: 20,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'La molecula está completa.\nYa puedes ver el resultado.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
            strutStyle: const StrutStyle(height: 1.5),
          ),
          const SizedBox(height: 20),
          QuimifyButton.gradient(
            height: 50,
            onPressed: () => _search(_sequence()),
            child: Text(
              'Resolver',
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
              // Buttons:
              const SizedBox(height: 10),
              Row(
                children: [
                  if (!_done)
                    Expanded(
                      child: AddCarbonButton(
                        height: buttonHeight,
                        enabled: _canBondCarbon(),
                        onPressed: _pressedBondCarbonButton,
                      ),
                    ),
                  if (_done)
                    Expanded(
                      child: QuimifyButton(
                        height: buttonHeight,
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
                  Expanded(
                    child: HydrogenateButton(
                      height: buttonHeight,
                      enabled: _canHydrogenate(),
                      onPressed: _pressedHydrogenateButton,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: HistoryButton(
                      height: buttonHeight,
                      onPressed: () => _showHistory(null),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: UndoButton(
                      height: buttonHeight,
                      onPressed: _undoButton,
                      enabled: _canUndo(),
                    ),
                  ),
                ],
              ),
              // Substituents:
              const SizedBox(height: 15 + 5),
              if (!_done) ...[
                const QuimifySectionTitle(
                  title: 'Sustituyentes',
                  helpDialog: NamingHelpDialog(
                    buttonHeight: buttonHeight,
                  ),
                ),
                const SizedBox(height: 15),
              ],
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  // To avoid rounded corners overflow:
                  clipBehavior: Clip.hardEdge,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 5, // + 15 from above SizedBox = 20
                        bottom: 20, // Bottom padding of the page
                      ),
                      child: !_done
                          ? Wrap(
                              runSpacing: 15,
                              children: _openChain()
                                  .getBondableGroups()
                                  .reversed
                                  .map((function) => groupToButton[function]!)
                                  .toList(),
                            )
                          : doneDialog,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
