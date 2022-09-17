import 'dart:math';

import 'package:cliente/organic/components/functions.dart';

import '../organic.dart';

class Substituent {
  Substituent(Functions function) {
    switch (function) {
      case Functions.acid:
      case Functions.amide:
      case Functions.nitrile:
      case Functions.aldehyde:
        _buildNormal(function, 3);
        break;
      case Functions.ketone:
        _buildNormal(function, 2);
        break;
      case Functions.carboxyl:
      case Functions.carbamoyl:
      case Functions.cyanide:
      case Functions.alcohol:
      case Functions.amine:
      case Functions.ether:
      case Functions.nitro:
      case Functions.bromine:
      case Functions.chlorine:
      case Functions.fluorine:
      case Functions.iodine:
      case Functions.hydrogen:
        _buildNormal(function, 1);
        break;
      default: // Radical, alkene or alkyne
        break;
    }
  }

  late Functions _function;
  late int _bondCount;

  // Only for radicals:
  late int _carbonCount;
  late bool _isIso;

  void _buildNormal(Functions function, int bonds) {
    _build(function, bonds, 0, false);
  }

  void _buildRadical(int carbons, bool iso) {
    _build(Functions.radical, 1, carbons, iso);
  }

  void _build(Functions function, int bonds, int carbons, bool iso) {
    _function = function;
    _bondCount = bonds;
    _carbonCount = carbons;
    _isIso = iso;
  }

  bool isLike(Functions function) => _function == function;

  bool isHalogen() => Organic.isHalogen(_function);

  bool equals(Substituent other) => _function == Functions.radical
      ? _carbonCount == other._carbonCount && _isIso == other._isIso
      : _function == other._function && _bondCount == other._bondCount;

  Functions getFunction() => _function;

  int getBonds() => _bondCount;

  @override
  String toString() {
    String result = '';

    switch (_function) {
      case Functions.carboxyl:
        result += 'COOH';
        break;
      case Functions.acid:
        result += 'OOH';
        break;
      case Functions.carbamoyl:
        result += 'CONH2';
        break;
      case Functions.amide:
        result += 'ONH2';
        break;
      case Functions.cyanide:
        result += 'CN';
        break;
      case Functions.nitrile:
        result += 'N';
        break;
      case Functions.aldehyde:
        result += 'HO';
        break;
      case Functions.ketone:
        result += 'O';
        break;
      case Functions.alcohol:
        result += 'OH';
        break;
      case Functions.amine:
        result += 'NH2';
        break;
      case Functions.ether:
        result += '-O-';
        break;
      case Functions.nitro:
        result += 'NO2';
        break;
      case Functions.bromine:
        result += 'Br';
        break;
      case Functions.chlorine:
        result += 'Cl';
        break;
      case Functions.fluorine:
        result += 'F';
        break;
      case Functions.iodine:
        result += 'I';
        break;
      case Functions.radical:
        result += _isIso
            ? '${'CH2' * max(0, _carbonCount - 3)}CH(CH3)2'
            : '${'CH2' * max(0, _carbonCount - 1)}CH3';
        break;
      case Functions.hydrogen:
        result += 'H';
        break;
      default:
        break;
    }

    return result.toString();
  }
}
