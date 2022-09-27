import 'package:cliente/organic/components/chain.dart';
import 'package:cliente/organic/components/functions.dart';
import 'package:cliente/organic/components/substituent.dart';
import 'package:cliente/organic/types/open_chain.dart';

class Simple extends OpenChain {
  Simple() {
    _chain = Chain(previousBonds: 0);
  }

  Simple.from(Chain other) {
    _chain = other;
  }

  late Chain _chain;

  @override
  OpenChain getCopy() => Simple.from(Chain.from(_chain));

  @override
  int getFreeBonds() => _chain.getFreeBonds();

  @override
  bool isDone() => _chain.isDone();

  @override
  List<Functions> getBondableFunctions() {
    List<Functions> bondableFunctions = [];

    if (getFreeBonds() > 2) {
      bondableFunctions.add(Functions.acid);
      bondableFunctions.add(Functions.amide);
      bondableFunctions.add(Functions.nitrile);
      bondableFunctions.add(Functions.aldehyde);
    }

    if (getFreeBonds() > 1) {
      bondableFunctions.add(Functions.ketone);
    }

    if (getFreeBonds() > 0) {
      bondableFunctions.add(Functions.alcohol);
      bondableFunctions.add(Functions.amine);
      bondableFunctions.add(Functions.nitro);
      bondableFunctions.add(Functions.bromine);
      bondableFunctions.add(Functions.chlorine);
      bondableFunctions.add(Functions.fluorine);
      bondableFunctions.add(Functions.iodine);
      bondableFunctions.add(Functions.radical);
      bondableFunctions.add(Functions.hydrogen);
    }

    return bondableFunctions;
  }

  @override
  void bondCarbon() => _chain.bondCarbon();

  @override
  void bondFunction(Functions function) =>
      bondSubstituent(Substituent(function));

  void bondSubstituent(Substituent substituent) => _chain.bond(substituent);

  @override
  String getFormula() => _chain.toString();
}
