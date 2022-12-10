import 'package:quimify_client/api/organic/components/chain.dart';
import 'package:quimify_client/api/organic/components/group.dart';
import 'package:quimify_client/api/organic/components/substituent.dart';
import 'package:quimify_client/api/organic/molecules/open_chain/open_chain.dart';

class Ether extends OpenChain {
  Ether(Chain firstChain) {
    _firstChain = firstChain; // [R - O] - R'

    if (_firstChain.isDone()) {
      _switchToSecondChain(); // R - O [- R']
    } else {
      _secondChain = null;
      _currentChain = _firstChain;
    }
  }

  Ether.copyFrom(Ether other) {
    _firstChain = Chain.copyFrom(other._firstChain);

    if (other._secondChain != null) {
      _secondChain = Chain.copyFrom(other._secondChain!);
      _currentChain = _secondChain!;
    } else {
      _secondChain = null;
      _currentChain = _firstChain;
    }
  }

  late Chain _firstChain; // R
  late Chain? _secondChain; // R'
  late Chain _currentChain; // ->

  // Interface:

  @override
  bool isDone() => _currentChain.isDone();

  @override
  int getFreeBondCount() => _currentChain.getFreeBondCount();

  @override
  List<Group> getBondableGroups() {
    List<Group> bondableGroups = [];

    if (_currentChain.getFreeBondCount() > 0) {
      bondableGroups.addAll([
        Group.nitro,
        Group.bromine,
        Group.chlorine,
        Group.fluorine,
        Group.iodine,
        Group.radical,
        Group.hydrogen,
      ]);
    }

    return bondableGroups;
  }

  @override
  OpenChain bondGroup(Group function) => bondSubstituent(Substituent(function));

  @override
  OpenChain bondSubstituent(Substituent substituent) {
    _currentChain.bondSubstituent(substituent);

    if (_currentChain == _firstChain && _firstChain.isDone()) {
        _switchToSecondChain();
    }

    return this;
  }

  @override
  bool canBondCarbon() =>
      _currentChain == _secondChain && _secondChain!.canBondCarbon();

  @override
  void bondCarbon() => _secondChain!.bondCarbon();

  @override
  String getStructure() {
    String firstChainStructure = _firstChain.toString();

    return _currentChain == _firstChain
        ? firstChainStructure.substring(0, firstChainStructure.length - 1)
        : firstChainStructure + _secondChain.toString();
  }

  @override
  OpenChain getCopy() => Ether.copyFrom(this);

  // Private:

  void _switchToSecondChain() {
    _secondChain = Chain(previousBonds: 1);
    _currentChain = _secondChain!;
  }
}
