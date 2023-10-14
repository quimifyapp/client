import 'package:collection/collection.dart';
import 'package:quimify_client/internet/api/organic/components/group.dart';
import 'package:quimify_client/internet/api/organic/components/substituent.dart';
import 'package:quimify_client/internet/api/organic/organic.dart';

class Carbon extends Organic {
  Carbon(int previousBonds) {
    _freeBondCount = 4 - previousBonds;
    _substituents = [];
  }

  Carbon.copyFrom(Carbon otherCarbon) {
    _freeBondCount = otherCarbon._freeBondCount;

    _substituents = [];
    for (Substituent otherSubstituent in otherCarbon._substituents) {
      _substituents.add(otherSubstituent);
    }
  }

  late int _freeBondCount;
  late List<Substituent> _substituents;

  // Interface:

  int getFreeBondCount() => _freeBondCount;

  bond(Substituent substituent) {
    _substituents.add(substituent);
    _freeBondCount -= substituent.getBondCount();
  }

  useBond() => _freeBondCount--;

  bool isBondedTo(Group group) {
    switch (group) {
      case Group.alkene:
        return _freeBondCount == 1; // -CO=
      case Group.alkyne:
        return _freeBondCount == 2; // -CH≡
      default:
        return _substituents.any((s) => s.getGroup() == group);
    }
  }

  int getAmountOfGroup(Group group) {
    if (Organic.isBond(group)) {
      return isBondedTo(group) ? 1 : 0;
    }

    return _substituents.where((s) => s.getGroup() == group).length;
  }

  int getAmountOfSubstituent(Substituent substituent) =>
      _substituents.where((listed) => listed == substituent).length;

  // Text:

  String _getStructure() {
    String result = 'C';

    // Hydrogen:

    int hydrogenCount = getAmountOfGroup(Group.hydrogen);

    if (hydrogenCount > 0) {
      result += Substituent(Group.hydrogen).toString();
      result += Organic.molecularQuantifierFor(hydrogenCount);
    }

    // Rest of them except ether:

    Set<Substituent> uniqueSubstituents = _substituents.toSet();
    uniqueSubstituents.removeWhere((Substituent s) =>
        s.getGroup() == Group.hydrogen || s.getGroup() == Group.ether);

    List<Substituent> uniqueOrderedSubstituents = uniqueSubstituents
        .sorted((a, b) => a.getGroup().index.compareTo(b.getGroup().index));

    if (uniqueOrderedSubstituents.length == 1) {
      // Only one kind except for hydrogen and ether
      Substituent substituent = uniqueOrderedSubstituents.first;
      Group group = substituent.getGroup();

      if (substituent.getBondCount() == 3 && group != Group.aldehyde) {
        result += substituent.toString(); // CHOOH, CONH2-...
      } else if (group == Group.aldehyde && hydrogenCount == 0) {
        result += substituent.toString(); // CHO
      } else if (group == Group.ketone && hydrogenCount == 0) {
        result += substituent.toString(); // -CO-
      } else if (Organic.isHalogen(group)) {
        result += substituent.toString(); // CHCl2, CF3-...
      } else {
        result += '($substituent)'; // CH(HO), CH(CH3)3-...
      }

      int amount = getAmountOfSubstituent(substituent);
      result += Organic.molecularQuantifierFor(amount);
    } else if (uniqueOrderedSubstituents.length > 1) {
      // More than one kind except for hydrogen and ether
      for (Substituent substituent in uniqueOrderedSubstituents) {
        int amount = getAmountOfSubstituent(substituent);
        String quantifier = Organic.molecularQuantifierFor(amount);
        result += '($substituent)$quantifier'; // C(OH)3(Cl), CH2(NO2)(CH3)...
      }
    }

    // Ether:

    if (isBondedTo(Group.ether)) {
      result += Substituent(Group.ether).toString(); // CHBr-O-
    }

    return result;
  }

  @override
  String toString() => _getStructure();
}
