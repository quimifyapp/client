import 'package:quimify_client/api/organic/components/chain.dart';
import 'package:quimify_client/api/organic/components/functional_group.dart';
import 'package:quimify_client/api/organic/components/substituent.dart';
import 'package:quimify_client/api/organic/compounds/open_chain/open_chain.dart';
import 'package:quimify_client/api/organic/compounds/open_chain/simple.dart';

class Ether extends OpenChain {
  Ether(Simple firstChain) {
    _firstChain = firstChain.getChain(); // [R - O] - R'

    if (_firstChain.isDone()) {
      _startSecondChain(); // R - O [- R']
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
  void bondCarbon() => _secondChain!.bondCarbon();

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
    String firstChainStructure = _firstChain.toString();

    return _currentChain == _firstChain
        ? firstChainStructure.substring(0, firstChainStructure.length - 1)
        : firstChainStructure + _secondChain.toString();
  }

  // Private:

  void _startSecondChain() {
    _secondChain = Chain(previousBonds: 1);
    _currentChain = _secondChain!;
  }
}
