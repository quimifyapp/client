import 'package:cliente/organic/components/substituent.dart';

import 'components/functions.dart';

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
      if (Enum.compareByIndex(substituents[i].getFunction(),
              substituents[i + 1].getFunction()) >
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

  static bool isHalogen(Functions function) => [
        Functions.bromine,
        Functions.chlorine,
        Functions.fluorine,
        Functions.iodine
      ].contains(function);
}
