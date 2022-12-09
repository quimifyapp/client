import 'package:quimify_client/api/organic/components/group.dart';
import 'package:quimify_client/api/organic/components/substituent.dart';
import 'package:quimify_client/api/organic/organic.dart';

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

  void bond(Substituent substituent) {
    _substituents.add(substituent);
    _freeBondCount -= substituent.getBonds();
  }

  void useBond() => _freeBondCount--;

  List<Substituent> getUniqueSubstituents() { // TODO set?
    List<Substituent> uniqueSubstituents = [];

    for (Substituent substituent in _substituents) {
      bool add = true;

      for (Substituent listed in uniqueSubstituents) {
        if (listed.equals(substituent)) {
          add = false;
          break;
        }
      }

      if (add) {
        uniqueSubstituents.add(substituent);
      }
    }

    return uniqueSubstituents;
  }

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
    int amount = 0;

    if (isBondedTo(group)) {
      if (group != Group.alkene && group != Group.alkyne) {
        for (Substituent substituent in _substituents) {
          if (substituent.getGroup() == group) {
            amount += 1;
          }
        }
      } else {
        amount = 1;
      }
    }

    return amount;
  }

  int getAmountOfSubstituent(Substituent substituent) =>
      _substituents.where((listed) => listed.equals(substituent)).length;

  @override
  String toString() {
    String result = 'C';

    // Se recogen los tipos de substituent:
    List<Substituent> uniqueSubstituents = getUniqueSubstituents();

    // Se ordenan según la prioridad de su función:
    Organic.orderByFunctions(uniqueSubstituents);

    // Se escribe los hidrógenos:
    Substituent hydrogen = Substituent(Group.hydrogen);
    int hydrogenCount = getAmountOfGroup(Group.hydrogen);
    if (hydrogenCount > 0) {
      result +=
          hydrogen.toString() + Organic.molecularQuantifier(hydrogenCount);
      uniqueSubstituents.removeLast(); // Se borra el hidrógeno de la lista
    }

    // Se escribe el resto de substituents excepto el éter:
    uniqueSubstituents.removeWhere((s) => s.getGroup() == Group.ether);

    if (uniqueSubstituents.length == 1) {
      // Solo hay un tipo además del hidrógeno y éter
      Substituent unique = uniqueSubstituents.first;

      String text = unique.toString();

      if (unique.getBonds() == 3 &&
          !(unique.getGroup() == Group.aldehyde && hydrogenCount > 0)) {
        result += text; // COOH, CHO...
      } else if (unique.isHalogen()) {
        result += text; // CHCl, CF...
      } else if (unique.getGroup() == Group.ketone && hydrogenCount == 0) {
        result += text; // CO
      } else {
        result += '($text)'; // Like "CH(OH)3"
      }

      result += Organic.molecularQuantifier(getAmountOfSubstituent(unique));
    } else if (uniqueSubstituents.length > 1) {
      // Hay más de un tipo además del hidrógeno y éter
      for (Substituent substituent in uniqueSubstituents) {
        String count =
            Organic.molecularQuantifier(getAmountOfSubstituent(substituent));
        result += '($substituent)$count'; // Like "C(OH)3(Cl)"
      }
    }

    // Ether:
    if (isBondedTo(Group.ether)) {
      result += Substituent(Group.ether).toString();
    }

    return result;
  }
}
