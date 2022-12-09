import 'dart:math';

import 'package:quimify_client/api/organic/components/group.dart';
import 'package:quimify_client/api/organic/organic.dart';

class Substituent extends Organic {
  Substituent(Group function) {
    switch (function) {
      case Group.acid:
      case Group.amide:
      case Group.nitrile:
      case Group.aldehyde:
        _buildNormal(function, 3);
        break;
      case Group.ketone:
        _buildNormal(function, 2);
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
        _buildNormal(function, 1);
        break;
      default: // Radical, alkene or alkyne
        break;
    }
  }

  Substituent.radical(int carbonCount, bool isIso) {
    _build(Group.radical, 1, carbonCount, isIso);
  }

  late Group _function;
  late int _bondCount;

  // Only for radicals:
  late int _carbonCount;
  late bool _isIso;

  void _buildNormal(Group function, int bonds) {
    _build(function, bonds, 0, false);
  }

  void _build(Group function, int bonds, int carbons, bool iso) {
    _function = function;
    _bondCount = bonds;
    _carbonCount = carbons;
    _isIso = iso;
  }

  bool isHalogen() => Organic.isHalogen(_function);

  bool equals(Substituent other) => _function == Group.radical
      ? _carbonCount == other._carbonCount && _isIso == other._isIso
      : _function == other._function && _bondCount == other._bondCount;

  Group getGroup() => _function;

  int getBonds() => _bondCount;

  @override
  String toString() {
    String result;

    switch (_function) {
      case Group.acid:
        result = 'OOH';
        break;
      case Group.amide:
        result = 'ONH2';
        break;
      case Group.carbamoyl:
        result = 'CONH2';
        break;
      case Group.nitrile:
        result = 'N';
        break;
      case Group.cyanide:
        result = 'CN';
        break;
      case Group.aldehyde:
        result = 'HO';
        break;
      case Group.ketone:
        result = 'O';
        break;
      case Group.alcohol:
        result = 'OH';
        break;
      case Group.amine:
        result = 'NH2';
        break;
      case Group.ether:
        result = '-O-';
        break;
      case Group.nitro:
        result = 'NO2';
        break;
      case Group.bromine:
        result = 'Br';
        break;
      case Group.chlorine:
        result = 'Cl';
        break;
      case Group.fluorine:
        result = 'F';
        break;
      case Group.iodine:
        result = 'I';
        break;
      case Group.radical:
        result = _isIso
            ? '${'CH2' * max(0, _carbonCount - 3)}CH(CH3)2'
            : '${'CH2' * max(0, _carbonCount - 1)}CH3';
        break;
      case Group.hydrogen:
        result = 'H';
        break;
      default:
        result = '';
        break;
    }

    return result;
  }
}
