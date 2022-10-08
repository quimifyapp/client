import 'dart:math';

import 'package:quimify_client/organic/components/functional_group.dart';
import 'package:quimify_client/organic/organic.dart';

class Substituent extends Organic {
  Substituent(FunctionalGroup function) {
    switch (function) {
      case FunctionalGroup.acid:
      case FunctionalGroup.amide:
      case FunctionalGroup.nitrile:
      case FunctionalGroup.aldehyde:
        _buildNormal(function, 3);
        break;
      case FunctionalGroup.ketone:
        _buildNormal(function, 2);
        break;
      case FunctionalGroup.carboxyl:
      case FunctionalGroup.carbamoyl:
      case FunctionalGroup.cyanide:
      case FunctionalGroup.alcohol:
      case FunctionalGroup.amine:
      case FunctionalGroup.ether:
      case FunctionalGroup.nitro:
      case FunctionalGroup.bromine:
      case FunctionalGroup.chlorine:
      case FunctionalGroup.fluorine:
      case FunctionalGroup.iodine:
      case FunctionalGroup.hydrogen:
        _buildNormal(function, 1);
        break;
      default: // Radical, alkene or alkyne
        break;
    }
  }

  Substituent.radical(int carbonCount, bool isIso) {
    _build(FunctionalGroup.radical, 1, carbonCount, isIso);
  }

  late FunctionalGroup _function;
  late int _bondCount;

  // Only for radicals:
  late int _carbonCount;
  late bool _isIso;

  void _buildNormal(FunctionalGroup function, int bonds) {
    _build(function, bonds, 0, false);
  }

  void _build(FunctionalGroup function, int bonds, int carbons, bool iso) {
    _function = function;
    _bondCount = bonds;
    _carbonCount = carbons;
    _isIso = iso;
  }

  bool isLike(FunctionalGroup function) => _function == function;

  bool isHalogen() => Organic.isHalogen(_function);

  bool equals(Substituent other) => _function == FunctionalGroup.radical
      ? _carbonCount == other._carbonCount && _isIso == other._isIso
      : _function == other._function && _bondCount == other._bondCount;

  FunctionalGroup getFunction() => _function;

  int getBonds() => _bondCount;

  @override
  String toString() {
    String result = '';

    switch (_function) {
      case FunctionalGroup.carboxyl:
        result += 'COOH';
        break;
      case FunctionalGroup.acid:
        result += 'OOH';
        break;
      case FunctionalGroup.carbamoyl:
        result += 'CONH2';
        break;
      case FunctionalGroup.amide:
        result += 'ONH2';
        break;
      case FunctionalGroup.cyanide:
        result += 'CN';
        break;
      case FunctionalGroup.nitrile:
        result += 'N';
        break;
      case FunctionalGroup.aldehyde:
        result += 'HO';
        break;
      case FunctionalGroup.ketone:
        result += 'O';
        break;
      case FunctionalGroup.alcohol:
        result += 'OH';
        break;
      case FunctionalGroup.amine:
        result += 'NH2';
        break;
      case FunctionalGroup.ether:
        result += '-O-';
        break;
      case FunctionalGroup.nitro:
        result += 'NO2';
        break;
      case FunctionalGroup.bromine:
        result += 'Br';
        break;
      case FunctionalGroup.chlorine:
        result += 'Cl';
        break;
      case FunctionalGroup.fluorine:
        result += 'F';
        break;
      case FunctionalGroup.iodine:
        result += 'I';
        break;
      case FunctionalGroup.radical:
        result += _isIso
            ? '${'CH2' * max(0, _carbonCount - 3)}CH(CH3)2'
            : '${'CH2' * max(0, _carbonCount - 1)}CH3';
        break;
      case FunctionalGroup.hydrogen:
        result += 'H';
        break;
      default:
        break;
    }

    return result.toString();
  }
}
