import 'package:quimify_client/api/organic/components/carbon.dart';
import 'package:quimify_client/api/organic/components/group.dart';
import 'package:quimify_client/api/organic/components/substituent.dart';
import 'package:quimify_client/api/organic/organic.dart';

class Chain extends Organic {
  Chain({required int previousBonds}) {
    _carbons = [Carbon(previousBonds)];
  }

  Chain.copyFrom(Chain other) {
    _carbons = [];

    for (Carbon otherCarbon in other._carbons) {
      _carbons.add(Carbon.copyFrom(otherCarbon));
    }
  }

  late List<Carbon> _carbons;

  // Interface:

  int getFreeBondCount() => _carbons.last.getFreeBondCount();

  bool isDone() => getFreeBondCount() == 0;

  Group? getPriorityGroup() {
    for (Group group in Group.values) {
      for (Carbon carbon in _carbons) {
        if (carbon.isBondedTo(group)) {
          return group;
        }
      }
    }

    return null;
  }

  bondGroup(Group functionalGroup) =>
      bondSubstituent(Substituent(functionalGroup));

  bondSubstituent(Substituent substituent) =>
      _carbons.last.bond(substituent);

  bool canBondCarbon() => [1, 2, 3].contains(getFreeBondCount());

  bondCarbon() {
    _carbons.last.useBond();
    _carbons.add(Carbon(_carbons.last.getFreeBondCount() + 1));
  }

  // Text:

  String _getStructure() {
    String structure = '';

    if (_carbons.isNotEmpty) {
      // First one:
      structure += _carbons.first.toString(); // Like CH

      // The rest, with last carbon's bonds:
      int lastOneFreeBonds = _carbons.first.getFreeBondCount();
      for (int i = 1; i < _carbons.length; i++) {
        structure += Organic.bondOfOrder(lastOneFreeBonds); // Like CH=
        structure += _carbons[i].toString(); // Like CH=CH

        lastOneFreeBonds = _carbons[i].getFreeBondCount();
      }

      // Last one's free bonds:
      if (lastOneFreeBonds > 0 && lastOneFreeBonds < 4) {
        structure += Organic.bondOfOrder(lastOneFreeBonds - 1);
        // Like CH=CH-CH2-C≡
      }
    }

    return structure;
  }

  @override
  String toString() => _getStructure();
}
