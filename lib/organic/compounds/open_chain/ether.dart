import 'package:quimify_client/organic/components/chain.dart';
import 'package:quimify_client/organic/components/functional_group.dart';
import 'package:quimify_client/organic/components/substituent.dart';
import 'package:quimify_client/organic/compounds/open_chain/open_chain.dart';
import 'package:quimify_client/organic/compounds/open_chain/simple.dart';

class Ether extends OpenChain {
  Ether(Simple firstChain) {
    _firstChain = firstChain.getChain();
    _firstChain.bondFunctionalGroup(FunctionalGroup.ether);

    if (_firstChain.isDone()) {
      _startSecondChain();
    } else {
      _secondChain = null;
      _currentChain = _firstChain;
    }
  }

  Ether.from(Chain firstChain, Chain? secondChain) {
    _firstChain = Chain.from(firstChain);

    if (secondChain != null) {
      _secondChain = Chain.from(secondChain);
      _currentChain = _secondChain!;
    } else {
      _secondChain = null;
      _currentChain = _firstChain;
    }
  }

  late Chain _firstChain; // R
  late Chain? _secondChain; // R'
  late Chain _currentChain; // ->

  @override
  OpenChain getCopy() => Ether.from(_firstChain, _secondChain);

  @override
  int getFreeBonds() => _currentChain.getFreeBonds();

  @override
  bool isDone() => _currentChain.isDone();

  @override
  bool canBondCarbon() =>
      _currentChain == _secondChain && !_currentChain.isDone();

  @override
  void bondCarbon() => _currentChain.bondCarbon();

  @override
  void bondSubstituent(Substituent substituent) {
    _currentChain.bondSubstituent(substituent);

    if (_currentChain == _firstChain && _firstChain.isDone()) {
      if (_currentChain.isDone()) {
        _startSecondChain();
      }
    }
  }

  @override
  void bondFunctionalGroup(FunctionalGroup function) =>
      bondSubstituent(Substituent(function));

  @override
  List<FunctionalGroup> getOrderedBondableGroups() => getFreeBonds() > 0
      ? [
          FunctionalGroup.nitro,
          FunctionalGroup.bromine,
          FunctionalGroup.chlorine,
          FunctionalGroup.fluorine,
          FunctionalGroup.iodine,
          FunctionalGroup.radical,
          FunctionalGroup.hydrogen,
        ]
      : [];

  @override
  String getStructure() {
    String firstChain = _firstChain.toString();

    return _currentChain == _firstChain
        ? firstChain.substring(0, firstChain.length - 1)
        : firstChain + _secondChain.toString();
  }

  // Private:

  void _startSecondChain() {
    _secondChain = Chain(previousBonds: 1);
    _currentChain = _secondChain!;
  }
}
