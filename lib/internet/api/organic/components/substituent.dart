import 'dart:math';

import 'package:quimify_client/internet/api/organic/components/group.dart';
import 'package:quimify_client/internet/api/organic/organic.dart';

class Substituent extends Organic {
  Substituent(Group group) {
    if(group == Group.radical) {
      throw ArgumentError('There is no unique substituent with functional '
          'group: $_group');
    }

    _group = group;

    switch (group) {
      case Group.acid:
      case Group.amide:
      case Group.nitrile:
      case Group.aldehyde:
        _bondCount = 3;
        break;
      case Group.ketone:
        _bondCount = 2;
        break;
      case Group.carbamoyl:
      case Group.cyanide:
      case Group.alcohol:
      case Group.amine:
      case Group.ether:
      case Group.nitro:
      case Group.bromine:
      case Group.chlorine:
      case Group.fluorine:
      case Group.iodine:
      case Group.hydrogen:
        _bondCount = 1;
        break;
      default:
        throw ArgumentError('There is no substituent with functional '
            'group: $_group');
    }

    _carbonCount = 0;
    _iso = false;
  }

  Substituent.radical(int carbonCount, bool iso) {
    _group = Group.radical;
    _bondCount = 1;
    _carbonCount = carbonCount;
    _iso = iso;
  }

  late Group _group;
  late int _bondCount;
  late int _carbonCount;
  late bool _iso;

  // Examples:

  // -Cl          → {Group.chlorine, bondCount: 1, carbonCount: 0, iso: false}
  // =O           → {Group.ketone,   bondCount: 2, carbonCount: 0, iso: false}
  // -CH2-CH2-CH3 → {Group.radical,  bondCount: 1, carbonCount: 3, iso: false}
  // -CH(CH3)-CH3 → {Group.radical,  bondCount: 1, carbonCount: 3, iso: true }

  // Queries:

  @override
  int get hashCode => Object.hash(_group, _bondCount, _carbonCount, _iso);

  @override
  bool operator ==(Object other) =>
      other is Substituent &&
      (_group == Group.radical
          ? _carbonCount == other._carbonCount && _iso == other._iso
          : _group == other._group && _bondCount == other._bondCount);

  // Text:

  String _getStructure() {
    switch (_group) {
      case Group.acid:
        return 'OOH';
      case Group.amide:
        return 'ONH2';
      case Group.carbamoyl:
        return 'COHN2';
      case Group.nitrile:
        return 'N';
      case Group.cyanide:
        return 'CN';
      case Group.aldehyde:
        return 'HO';
      case Group.ketone:
        return 'O';
      case Group.alcohol:
        return 'OH';
      case Group.amine:
        return 'NH2';
      case Group.ether:
        return '-O-';
      case Group.nitro:
        return 'NO2';
      case Group.bromine:
        return 'Br';
      case Group.chlorine:
        return 'Cl';
      case Group.fluorine:
        return 'F';
      case Group.iodine:
        return 'I';
      case Group.radical:
        return _getRadicalStructure();
      case Group.hydrogen:
        return 'H';
      default:
        throw ArgumentError('Unknown structure for substituent with '
            'functional group: $_group');
    }
  }

  String _getRadicalStructure() => _iso
      ? '${'CH2' * max(0, _carbonCount - 3)}CH(CH3)2'
      : '${'CH2' * max(0, _carbonCount - 1)}CH3';

  @override
  String toString() => _getStructure();

  // Getters:

  Group getGroup() => _group;

  int getBondCount() => _bondCount;
}
