import 'package:quimify_client/api/organic/components/chain.dart';
import 'package:quimify_client/api/organic/components/group.dart';
import 'package:quimify_client/api/organic/components/substituent.dart';
import 'package:quimify_client/api/organic/molecules/open_chain/ether.dart';
import 'package:quimify_client/api/organic/molecules/open_chain/open_chain.dart';

class Simple extends OpenChain {
  Simple() {
    _chain = Chain(previousBonds: 0);
  }

  Simple.copyFrom(Simple other) {
    _chain = Chain.copyFrom(other._chain);
  }

  late Chain _chain;

  // Interface:

  @override
  bool isDone() => _chain.isDone();

  @override
  int getFreeBondCount() => _chain.getFreeBondCount();

  @override
  List<Group> getBondableGroups() {
    List<Group> orderedBondableGroups = [];

    int freeBondCount = _chain.getFreeBondCount();

    if (freeBondCount > 2) {
      orderedBondableGroups.addAll([
        Group.acid,
        Group.amide,
        Group.nitrile,
        Group.aldehyde,
      ]);
    }

    if (freeBondCount > 1) {
      orderedBondableGroups.add(Group.ketone);
    }

    if (freeBondCount > 0) {
      orderedBondableGroups.addAll([
        Group.alcohol,
        Group.amine,
      ]);

      if (_wouldBePriority(Group.ether)) {
        orderedBondableGroups.add(Group.ether);
      }

      orderedBondableGroups.addAll([
        Group.nitro,
        Group.bromine,
        Group.chlorine,
        Group.fluorine,
        Group.iodine,
        Group.radical,
        Group.hydrogen,
      ]);
    }

    return orderedBondableGroups;
  }

  @override
  OpenChain bondGroup(Group function) =>
      bondSubstituent(Substituent(function));

  @override
  OpenChain bondSubstituent(Substituent substituent) {
    OpenChain bondedOpenChain;

    if(substituent.getGroup() == Group.ether) {
      bondedOpenChain = Ether(_chain);
      bondedOpenChain.bondGroup(Group.ether);
    }
    else {
      bondedOpenChain = this;
      _chain.bondSubstituent(substituent);
    }

    return bondedOpenChain;
  }

  @override
  bool canBondCarbon() => _chain.canBondCarbon();

  @override
  void bondCarbon() => _chain.bondCarbon();

  @override
  String getStructure() => _chain.toString();

  @override
  OpenChain getCopy() => Simple.copyFrom(this);

  // Private:

  bool _wouldBePriority(Group group) {
    Group? priorityGroup = _chain.getPriorityGroup();

    if(priorityGroup != null) {
      return priorityGroup.index >= group.index;
    } else {
      return true;
    }
  }
}
