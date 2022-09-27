import 'package:cliente/organic/components/chain.dart';
import 'package:cliente/organic/components/functions.dart';
import 'package:cliente/organic/components/substituent.dart';
import 'package:cliente/organic/types/open_chain.dart';

class Ether extends OpenChain {
  Ether() {
    _primaryChain = Chain(previousBonds: 0);
    _secondaryChain = Chain(previousBonds: 1);

    _currentChain = _primaryChain;
    _isEther = false;
  }

  Ether.from(Chain primaryOther, Chain secondaryOther, Chain currentOther,
      bool isEther) {
    _primaryChain = Chain.from(primaryOther);
    _secondaryChain = Chain.from(secondaryOther);
    _currentChain =
        currentOther == primaryOther ? _primaryChain : _secondaryChain;
    _isEther = isEther;
  }

  late Chain _primaryChain, _secondaryChain, _currentChain;
  late bool _isEther;

  @override
  OpenChain getCopy() =>
      Ether.from(_primaryChain, _secondaryChain, _currentChain, _isEther);

  @override
  int getFreeBonds() => _currentChain.getFreeBonds();

  @override
  bool isDone() => _currentChain.isDone();

  @override
  List<Functions> getBondableFunctions() {
    List<Functions> bondableFunctions = [];

    if (getFreeBonds() > 0) {
      if (_isEther || getFreeBonds() > 1) {
        bondableFunctions.add(Functions.nitro);
        bondableFunctions.add(Functions.bromine);
        bondableFunctions.add(Functions.chlorine);
        bondableFunctions.add(Functions.fluorine);
        bondableFunctions.add(Functions.iodine);
        bondableFunctions.add(Functions.radical);
        bondableFunctions.add(Functions.hydrogen);
      } else {
        bondableFunctions.add(Functions.ether);
      }
    }

    return bondableFunctions;
  }

  @override
  void bondFunction(Functions function) =>
      bondSubstituent(Substituent(function));

  @override
  void bondCarbon() => _currentChain.bondCarbon();

  void bondSubstituent(Substituent substituent) {
    _currentChain.bond(substituent);

    if (substituent.isLike(Functions.ether)) {
      _currentChain = _secondaryChain;
      _isEther = true;
    }
  }

  @override
  String getFormula() => _isEther
      ? _primaryChain.toString() + _secondaryChain.toString()
      : _primaryChain.toString();
}
