import 'package:quimify_client/api/organic/components/group.dart';
import 'package:quimify_client/api/organic/components/substituent.dart';

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
      if (Enum.compareByIndex(substituents[i].getGroup(),
              substituents[i + 1].getGroup()) >
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

  static bool isHalogen(Group function) => [
        Group.bromine,
        Group.chlorine,
        Group.fluorine,
        Group.iodine
      ].contains(function);
}
