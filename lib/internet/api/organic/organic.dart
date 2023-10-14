import 'package:quimify_client/internet/api/organic/components/group.dart';

// This class wraps up organic utilities.

class Organic {
  static final Set<Group> _halogenGroups = {
    Group.bromine,
    Group.chlorine,
    Group.fluorine,
    Group.iodine,
  };

  // Queries:

  static bool isHalogen(Group group) => _halogenGroups.contains(group);

  static bool isBond(Group group) =>
      group == Group.alkene || group == Group.alkyne;

  // Text:

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

  static String molecularQuantifierFor(int amount) => (amount != 1)
      ? amount.toString() // CO2
      : ''; // CO
}
