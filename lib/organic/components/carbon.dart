import 'package:quimify_client/organic/components/functional_group.dart';
import 'package:quimify_client/organic/components/substituent.dart';
import 'package:quimify_client/organic/organic.dart';

class Carbon extends Organic {
  Carbon(int previousBonds) {
    _freeBonds = 4 - previousBonds;
    _substituents = [];
  }

  Carbon.from(Carbon otherCarbon) {
    _freeBonds = otherCarbon._freeBonds;

    _substituents = [];
    for (Substituent otherSubstituent in otherCarbon._substituents) {
      _substituents.add(otherSubstituent);
    }
  }

  late int _freeBonds;
  late List<Substituent> _substituents;

  void bond(Substituent substituent) {
    _substituents.add(substituent);
    _freeBonds -= substituent.getBonds();
  }

  void bondCarbon() => _freeBonds--;

  int getFreeBonds() => _freeBonds;

  List<Substituent> getUniqueSubstituents() {
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

  bool hasFunctionalGroup(FunctionalGroup function) {
    switch (function) {
      case FunctionalGroup.alkene:
        return _freeBonds == 1; // As in -CO=
      case FunctionalGroup.alkyne:
        return _freeBonds == 2; // As in -CH≡
      default:
        return _substituents.any((substituent) => substituent.isLike(function));
    }
  }

  int getAmountOfSubstituent(Substituent substituent) =>
      _substituents.where((listed) => listed.equals(substituent)).length;

  int getAmountOfFunction(FunctionalGroup functions) {
    int amount = 0;

    if (hasFunctionalGroup(functions)) {
      if (functions != FunctionalGroup.alkene &&
          functions != FunctionalGroup.alkyne) {
        for (Substituent substituent in _substituents) {
          if (substituent.isLike(functions)) {
            amount += 1;
          }
        }
      } else {
        amount = 1;
      }
    }

    return amount;
  }

  @override
  String toString() {
    String result = 'C';

    // Se recogen los tipos de substituent:
    List<Substituent> uniqueSubstituents =
        getUniqueSubstituents(); // Sin repetirse

    // Se ordenan según la prioridad de su función:
    Organic.orderByFunctions(uniqueSubstituents);

    // Se escribe los hidrógenos:
    Substituent hydrogen = Substituent(FunctionalGroup.hydrogen);
    int cantidad = getAmountOfFunction(FunctionalGroup.hydrogen);
    if (cantidad > 0) {
      result += hydrogen.toString() + Organic.molecularQuantifier(cantidad);
      uniqueSubstituents.removeLast(); // Se borra el hidrógeno de la lista
    }

    // Se escribe el resto de substituents excepto el éter:
    uniqueSubstituents.removeWhere(
        (substituent) => substituent.isLike(FunctionalGroup.ether));

    if (uniqueSubstituents.length == 1) {
      // Solo hay un tipo además del hidrógeno y éter
      Substituent unique = uniqueSubstituents.first;

      String text = unique.toString();

      if ((unique.isLike(FunctionalGroup.ketone) ||
              unique.isHalogen() ||
              unique.getBonds() == 3) &&
          !unique.isLike(FunctionalGroup.aldehyde)) {
        result += text; // Like "CN", "CCl", "COOH", "C(O)(NH2)", "CHO"...
      } else {
        result += '($text)'; // Like "CH(OH)3"
      }

      result += Organic.molecularQuantifier(getAmountOfSubstituent(unique));
    } else if (uniqueSubstituents.length > 1) {
      // Hay más de un tipo además del hidrógeno y éter
      for (Substituent substituent in uniqueSubstituents) {
        result +=
            '($substituent)${Organic.molecularQuantifier(getAmountOfSubstituent(substituent))}'; // Like "C(OH)3(Cl)"
      }
    }

    // Ether:
    if (hasFunctionalGroup(FunctionalGroup.ether)) {
      result += Substituent(FunctionalGroup.ether).toString();
    }

    return result;
  }
}
