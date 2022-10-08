import 'package:quimify_client/organic/components/chain.dart';
import 'package:quimify_client/organic/components/functional_group.dart';
import 'package:quimify_client/organic/components/substituent.dart';
import 'package:quimify_client/organic/compounds/open_chain/open_chain.dart';
import 'package:quimify_client/organic/compounds/open_chain/simple.dart';

class Ether extends OpenChain {
  Ether(Simple firstChain) {
    _firstChain = firstChain.getChain();
    _firstChain.bondFunctionalGroup(FunctionalGroup.ether);
    _secondChain = Chain(previousBonds: 1);
  }

  Ether.from(Chain firstChain, Chain secondChain) {
    _firstChain = Chain.from(firstChain);
    _secondChain = Chain.from(secondChain);
  }

  late Chain _firstChain, _secondChain; // R, R'

  @override
  OpenChain getCopy() => Ether.from(_firstChain, _secondChain);

  @override
  int getFreeBonds() => _secondChain.getFreeBonds();

  @override
  bool isDone() => _secondChain.isDone();

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
  void bondCarbon() => _secondChain.bondCarbon();

  @override
  void bondSubstituent(Substituent substituent) =>
      _secondChain.bondSubstituent(substituent);

  @override
  void bondFunctionalGroup(FunctionalGroup function) =>
      bondSubstituent(Substituent(function));

  @override
  String getStructure() => _firstChain.toString() + _secondChain.toString();
}
