import 'package:quimify_client/organic/components/functional_group.dart';
import 'package:quimify_client/organic/components/substituent.dart';
import 'package:quimify_client/organic/organic.dart';

import 'carbon.dart';

class Chain extends Organic {
  Chain({required int previousBonds}) {
    _carbons = [Carbon(previousBonds)];
  }

  Chain.from(Chain other) {
    _carbons = [];

    for (Carbon otherCarbon in other._carbons) {
      _carbons.add(Carbon.from(otherCarbon));
    }
  }

  late List<Carbon> _carbons;

  int getFreeBonds() => _carbons.last.getFreeBonds();

  bool isDone() => getFreeBonds() == 0;

  bool hasFunctionalGroup(FunctionalGroup functionalGroup) =>
      _carbons.any((carbon) => carbon.hasFunctionalGroup(functionalGroup));

  void bondCarbon() {
    _carbons.last.bondCarbon();
    _carbons.add(Carbon(_carbons.last.getFreeBonds() + 1));
  }

  void bondSubstituent(Substituent substituent) =>
      _carbons.last.bond(substituent);

  void bondFunctionalGroup(FunctionalGroup functionalGroup) =>
      bondSubstituent(Substituent(functionalGroup));

  Set<Substituent> getBondedSubstituents() {
    Set<Substituent> bondedSubstituents = {};

    for (Carbon carbon in _carbons) {
      bondedSubstituents.addAll(carbon.getUniqueSubstituents());
    }

    return bondedSubstituents;
  }

  @override
  String toString() {
    String structure = '';

    if (_carbons.isNotEmpty) {
      // First one:
      structure += _carbons.first.toString(); // Like CH

      // The rest, with last carbon's bonds:
      int lastOneFreeBonds = _carbons.first.getFreeBonds();
      for (int i = 1; i < _carbons.length; i++) {
        structure += Organic.bondOfOrder(lastOneFreeBonds); // Like CH=
        structure += _carbons[i].toString(); // Like CH=CH

        lastOneFreeBonds = _carbons[i].getFreeBonds();
      }

      // Last one's free bonds:
      if (lastOneFreeBonds > 0 && lastOneFreeBonds < 4) {
        structure += Organic.bondOfOrder(lastOneFreeBonds - 1);
        // Like CH=CH-CH2-C≡
      }
    }

    return structure;
  }
}
