import 'package:quimify_client/organic/components/substituent.dart';

import 'components/functional_group.dart';

// This class serves as a parent for any organic chemistry component.

class Organic {
  static String bondOfOrder(int order) {
    switch (order) {
      case 0:
        return '-';
      case 1:
        return '=';
      case 2:
        return '≡';
      default:
        return '';
    }
  }

  static String molecularQuantifier(int amount) => (amount != 1)
      ? amount.toString() // Como en "CO2"
      : ''; // Como en "CO"

  static void orderByFunctions(List<Substituent> substituents) {
    for (int i = 0; i < substituents.length - 1;) {
      if (Enum.compareByIndex(substituents[i].getFunctionalGroup(),
              substituents[i + 1].getFunctionalGroup()) >
          0) {
        Substituent temp = substituents[i];
        substituents[i] = substituents[i + 1];
        substituents[i + 1] = temp;
        i = 0; // get(i) > get(i + 1)
      } else {
        i++; // get(i) <= get(i + 1)
      }
    }
  }

  static bool isHalogen(FunctionalGroup function) => [
        FunctionalGroup.bromine,
        FunctionalGroup.chlorine,
        FunctionalGroup.fluorine,
        FunctionalGroup.iodine
      ].contains(function);
}
