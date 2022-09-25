import 'package:cliente/organic/components/substituent.dart';

import '../organic.dart';
import 'functions.dart';

class Carbon extends Organic {
  Carbon(int previousBonds) {
    _freeBonds = 4 - previousBonds;
    _substituents = [];
  }

  Carbon.from(Carbon otherCarbon) {
    _freeBonds = otherCarbon._freeBonds;

    _substituents = [];
    for(Substituent otherSubstituent in otherCarbon._substituents) {
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

      for(Substituent listed in uniqueSubstituents) {
        if(listed.equals(substituent)) {
          add = false;
          break;
        }
      }

      if(add) {
        uniqueSubstituents.add(substituent);
      }
    }

    return uniqueSubstituents;
  }

  bool contains(Functions function) {
    switch (function) {
      case Functions.alkene:
        return _freeBonds == 1; // Como en -CO=
      case Functions.alkyne:
        return _freeBonds == 2; // Como en -CH#
      default:
        for (Substituent substituent in _substituents) {
          if (substituent.isLike(function)) {
            return true;
          }
        }

        return false;
    }
  }

  int getAmountOfSubstituent(Substituent substituent) =>
      _substituents.where((listed) => listed.equals(substituent)).length;

  int getAmountOfFunction(Functions functions) {
    int amount = 0;

    if (contains(functions)) {
      if (functions != Functions.alkene && functions != Functions.alkyne) {
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
    Substituent hydrogen = Substituent(Functions.hydrogen);
    int cantidad = getAmountOfFunction(Functions.hydrogen);
    if (cantidad > 0) {
      result += hydrogen.toString() + Organic.molecularQuantifier(cantidad);
      uniqueSubstituents.removeLast(); // Se borra el hidrógeno de la lista
    }

    // Se escribe el resto de substituents excepto el éter:
    uniqueSubstituents
        .removeWhere((substituent) => substituent.isLike(Functions.ether));

    if (uniqueSubstituents.length == 1) {
      // Solo hay un tipo además del hidrógeno y éter
      Substituent unique = uniqueSubstituents.first;

      String text = unique.toString();

      if (text.length == 1 || unique.isHalogen() || unique.getBonds() == 3) {
        result += text; // Like "CN", "CCl", "COOH", "C(O)(NH2)", "CHO"...
      } else {
        result += '($text)'; // Like "CH(OH)3"
      }

      result += Organic.molecularQuantifier(getAmountOfSubstituent(unique));
    } else if (uniqueSubstituents.length > 1) {
      // Hay más de un tipo además del hidrógeno y éter
      for (Substituent substituent in uniqueSubstituents) {
        result += '($substituent)${Organic.molecularQuantifier(
            getAmountOfSubstituent(substituent))}'; // Like "C(OH)3(Cl)"
      }
    }

    // Ether:
    if (contains(Functions.ether)) {
      result += Substituent(Functions.ether).toString();
    }

    return result;
  }
}
