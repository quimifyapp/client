import 'package:flutter/material.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/internet/api/api.dart';
import 'package:quimify_client/internet/api/organic/components/group.dart';
import 'package:quimify_client/internet/api/organic/components/substituent.dart';
import 'package:quimify_client/internet/api/organic/molecules/open_chain/open_chain.dart';
import 'package:quimify_client/internet/api/organic/molecules/open_chain/simple.dart';
import 'package:quimify_client/internet/api/results/organic_result.dart';
import 'package:quimify_client/internet/internet.dart';
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
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/dialogs/loading_indicator.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/message_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/no_internet_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/report/report_dialog.dart';
import 'package:quimify_client/pages/widgets/objects/history_button.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_button.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_mascot_message.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/storage/history/history.dart';
import 'package:quimify_client/text.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class NamingPage extends StatefulWidget {
  const NamingPage({Key? key}) : super(key: key);

  @override
  State<NamingPage> createState() => _NamingPageState();
}

class _NamingPageState extends State<NamingPage> {
  // static const String _title = 'Nombrar orgánicos';

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
    Ads().showInterstitial(); // There will be a result most of the times

    showLoadingIndicator(context);

    OrganicResult? result = await Api().getOrganicFromStructure(sequence);

    if (result != null) {
      if (!result.found) {
        if (!mounted) return null; // For security reasons
        const MessageDialog(title: 'Sin resultado').show(context);

        return null;
      }

      _showResult(result);

      History().saveOrganicName(result, sequence);
    } else {
      if (!mounted) return null; // For security reasons

      if (await hasInternetConnection()) {
        const MessageDialog(
          title: 'Sin resultado',
        ).show(context);
      } else {
        noInternetDialog(context).show(context);
      }
    }

    hideLoadingIndicator();

    return result;
  }

  _showResult(OrganicResult organicResult) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => OrganicResultPage(
          title: context.l10n.nameOrganic,
          organicResultView: OrganicResultView(
            fields: {
              if (organicResult.structure != null)
                context.l10n.formula: formatStructure(organicResult.structure!),
              if (organicResult.name != null)
                context.l10n.name: organicResult.name!,
              if (organicResult.molecularMass != null)
                context.l10n.molecularMass:
                    '${formatMolecularMass(organicResult.molecularMass!)}'
                        ' g/mol',
            },
            imageProvider: organicResult.url2D != null
                ? NetworkImage(organicResult.url2D!)
                : null,
            url3D: organicResult.url3D,
            onHistoryPressed: _showHistory,
            reportDialog: ReportDialog(
              details: '${context.l10n.resultOf}\n"'
                  '${formatStructure(organicResult.structure!)}"',
              reportContext: context.l10n.nameOrganic,
              reportDetails:
                  '${context.l10n.resultOf} ${_sequence()}: $organicResult',
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
          onStartPressed: () {},
          entries: History()
              .getOrganicNames()
              .map((e) => HistoryEntry(
                    query: e.sequence,
                    fields: [
                      HistoryField(
                        context.l10n.formula,
                        formatStructure(e.structure!),
                      ),
                      HistoryField(
                        context.l10n.name,
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
      MessageDialog(
        title: context.l10n.nothingToUndo,
        details: context.l10n.tryToBondASubstituent,
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
      MessageDialog(
        title: context.l10n.emptyMolecule,
        details: context
            .l10n.itIsNotYetPossibleToBondAnotherCarbonTryBondingASubstituent,
      ).show(context);
    } else {
      MessageDialog(
        title: context.l10n.noNeed,
        details: context
            .l10n.anotherCarbonWillBondToTheOxygenWhenYouCompleteThisCarbon,
      ).show(context);
    }
  }

  _pressedHydrogenateButton() {
    if (_canHydrogenate()) {
      do {
        _pressedGroupButton(Group.hydrogen);
      } while (_openChain().getFreeBondCount() > 1);
    } else {
      MessageDialog(
        title: context.l10n.completeMolecule,
        details: context.l10n.thereAreNoFreeValencesLeftToBondMoreHydrogens,
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
        name: context.l10n.hydrogen,
        onPressed: () => _pressedGroupButton(Group.hydrogen),
      ),
      Group.radical: GroupButton(
        bonds: 1,
        structure: 'CH2 – CH3',
        name: context.l10n.radical,
        onPressed: _pressedRadicalButton,
      ),
      Group.iodine: GroupButton(
        bonds: 1,
        structure: 'I',
        name: context.l10n.iodine,
        onPressed: () => _pressedGroupButton(Group.iodine),
      ),
      Group.fluorine: GroupButton(
        bonds: 1,
        structure: 'F',
        name: context.l10n.fluorine,
        onPressed: () => _pressedGroupButton(Group.fluorine),
      ),
      Group.chlorine: GroupButton(
        bonds: 1,
        structure: 'Cl',
        name: context.l10n.chlorine,
        onPressed: () => _pressedGroupButton(Group.chlorine),
      ),
      Group.bromine: GroupButton(
        bonds: 1,
        structure: 'Br',
        name: context.l10n.bromine,
        onPressed: () => _pressedGroupButton(Group.bromine),
      ),
      Group.nitro: GroupButton(
        bonds: 1,
        structure: 'NO2',
        name: context.l10n.nitro,
        onPressed: () => _pressedGroupButton(Group.nitro),
      ),
      Group.ether: GroupButton(
        bonds: 1,
        structure: 'O –',
        name: context.l10n.ether,
        onPressed: () => _pressedGroupButton(Group.ether),
      ),
      Group.amine: GroupButton(
        bonds: 1,
        structure: 'NH2',
        name: context.l10n.amine,
        onPressed: () => _pressedGroupButton(Group.amine),
      ),
      Group.alcohol: GroupButton(
        bonds: 1,
        structure: 'OH',
        name: context.l10n.alcohol,
        onPressed: () => _pressedGroupButton(Group.alcohol),
      ),
      Group.ketone: GroupButton(
        bonds: 2,
        structure: 'O',
        name: context.l10n.ketone,
        onPressed: () => _pressedGroupButton(Group.ketone),
      ),
      Group.aldehyde: GroupButton(
        bonds: 3,
        structure: 'HO',
        name: context.l10n.aldehyde,
        onPressed: () => _pressedGroupButton(Group.aldehyde),
      ),
      Group.nitrile: GroupButton(
        bonds: 3,
        structure: 'N',
        name: context.l10n.nitrile,
        onPressed: () => _pressedGroupButton(Group.nitrile),
      ),
      Group.amide: GroupButton(
        bonds: 3,
        structure: 'ONH2',
        name: context.l10n.amide,
        onPressed: () => _pressedGroupButton(Group.amide),
      ),
      Group.acid: GroupButton(
        bonds: 3,
        structure: 'OOH',
        name: context.l10n.acid,
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

    return PopScope(
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          return;
        }

        hideLoadingIndicator();
      },
      child: QuimifyScaffold(
        bannerAdName: runtimeType.toString(),
        header: QuimifyPageBar(title: context.l10n.nameOrganic),
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
                  color: QuimifyColors.foreground(context),
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
                        style: TextStyle(
                          fontFamily: 'CeraProBoldCustom',
                          fontSize: 28,
                          color: QuimifyColors.teal(),
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
                          color: QuimifyColors.inverseText(context),
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
              const SizedBox(height: 15),
              if (!_done) ...[
                QuimifySectionTitle(
                  title: context.l10n.substituents,
                  helpDialog: NamingHelpDialog(
                    buttonHeight: buttonHeight,
                  ),
                ),
                const SizedBox(height: 15 + 5),
              ],
              if (_done) const SizedBox(height: 5),
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
                          : QuimifyMascotMessage(
                              tone: QuimifyMascotTone.positive,
                              title: context.l10n.congratulations,
                              details: context.l10n
                                  .theMoleculeIsCompleteYouCanNowSeeTheResult,
                              buttonLabel: context.l10n.solve,
                              onButtonPressed: () => _search(_sequence()),
                            ),
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
