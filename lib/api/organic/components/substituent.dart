import 'dart:math';

import 'package:quimify_client/api/organic/components/group.dart';
import 'package:quimify_client/api/organic/organic.dart';

class Substituent extends Organic {
  Substituent(Group group) {
    _build(group, _groupToBoundCount[group]!, 0, false);
  }

  Substituent.radical(int carbonCount, bool isIso) {
    _build(Group.radical, 1, carbonCount, isIso);
  }

  void _build(Group group, int bondCount, int carbonCount, bool isIso) {
    _group = group;
    _bondCount = bondCount;
    _carbonCount = carbonCount;
    _isIso = isIso;
  }

  late Group _group;
  late int _bondCount;
  late int _carbonCount;
  late bool _isIso;

  /* Examples:
	-Cl           → { Group.chlorine, bondCount: 1, carbonCount: 0, isIso: false }
	=O            → { Group.ketone,   bondCount: 2, carbonCount: 0, isIso: false }
	-CH2-CH2-CH3  → { Group.radical,  bondCount: 1, carbonCount: 3, isIso: false }
	-CH(CH3)-CH3  → { Group.radical,  bondCount: 1, carbonCount: 3, isIso: true  }
	*/

  // Constants:

  static final Map<Group, int> _groupToBoundCount = {
    Group.acid: 3,
    Group.amide: 3,
    Group.carbamoyl: 1,
    Group.nitrile: 3,
    Group.cyanide: 1,
    Group.aldehyde: 3,
    Group.ketone: 2,
    Group.alcohol: 1,
    Group.amine: 1,
    Group.ether: 1,
    Group.nitro: 1,
    Group.bromine: 1,
    Group.chlorine: 1,
    Group.fluorine: 1,
    Group.iodine: 1,
    Group.hydrogen: 1,
  };

  static final Map<Group, String> _groupToStructure = {
    Group.acid: 'OOH',
    Group.amide: 'ONH2',
    Group.carbamoyl: 'COHN2',
    Group.nitrile: 'N',
    Group.cyanide: 'CN',
    Group.aldehyde: 'HO',
    Group.ketone: 'O',
    Group.alcohol: 'OH',
    Group.amine: 'NH2',
    Group.ether: '-O-',
    Group.nitro: 'NO2',
    Group.bromine: 'Br',
    Group.chlorine: 'Cl',
    Group.fluorine: 'F',
    Group.iodine: 'I',
    Group.hydrogen: 'H',
  };

  // Queries:

  bool equals(Substituent other) => _group == Group.radical
      ? _carbonCount == other._carbonCount && _isIso == other._isIso
      : _group == other._group && _bondCount == other._bondCount;

  // Text:

  String _getStructure() {
    if(_group == Group.radical) {
      return _isIso
          ? '${'CH2' * max(0, _carbonCount - 3)}CH(CH3)2'
          : '${'CH2' * max(0, _carbonCount - 1)}CH3';
    }

    return _groupToStructure[_group]!;
  }

  @override
  String toString() => _getStructure();

  // Getters:

  Group getGroup() => _group;

  int getBondCount() => _bondCount;
}
