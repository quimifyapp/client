import 'package:cliente/organic/components/chain.dart';
import 'package:cliente/organic/components/functional_group.dart';
import 'package:cliente/organic/components/substituent.dart';
import 'package:cliente/organic/compounds/open_chain/open_chain.dart';

class Simple extends OpenChain {
  Simple() {
    _chain = Chain(previousBonds: 0);
  }

  Simple.from(Chain other) {
    _chain = other;
  }

  late Chain _chain;

  @override
  OpenChain getCopy() => Simple.from(Chain.from(_chain));

  @override
  int getFreeBonds() => _chain.getFreeBonds();

  @override
  bool isDone() => _chain.isDone();

  @override
  List<FunctionalGroup> getOrderedBondableGroups() {
    List<FunctionalGroup> orderedBondableGroups = [];

    if (getFreeBonds() > 2) {
      orderedBondableGroups.addAll([
        FunctionalGroup.acid,
        FunctionalGroup.amide,
        FunctionalGroup.nitrile,
        FunctionalGroup.aldehyde,
      ]);
    }

    if (getFreeBonds() > 1) {
      orderedBondableGroups.add(FunctionalGroup.ketone);
    }

    if (getFreeBonds() > 0) {
      orderedBondableGroups.addAll([
        FunctionalGroup.alcohol,
        FunctionalGroup.amine,
      ]);

      if (getFreeBonds() == 1) {
        orderedBondableGroups.add(FunctionalGroup.ether);
      }

      orderedBondableGroups.addAll([
        FunctionalGroup.nitro,
        FunctionalGroup.bromine,
        FunctionalGroup.chlorine,
        FunctionalGroup.fluorine,
        FunctionalGroup.iodine,
        FunctionalGroup.radical,
        FunctionalGroup.hydrogen,
      ]);
    }

    return orderedBondableGroups;
  }

  @override
  void bondCarbon() => _chain.bondCarbon();

  @override
  void bondFunctionalGroup(FunctionalGroup function) =>
      bondSubstituent(Substituent(function));

  @override
  void bondSubstituent(Substituent substituent) =>
      _chain.bondSubstituent(substituent);

  @override
  String getStructure() => _chain.toString();

  Chain getChain() => _chain;
}
