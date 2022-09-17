import '../components/chain.dart';
import '../components/functions.dart';
import '../components/substituent.dart';

class Simple {
  Simple() {
    _chain = Chain();
  }

  late Chain _chain;

  _getFreeBonds() => _chain.getFreeBonds();

  bool isDone() => _chain.isDone();

  List<Functions> getAvailableSubstituents() {
    List<Functions> available = [];

    if(_getFreeBonds() > 2) {
      available.add(Functions.acid);
      available.add(Functions.amide);
      available.add(Functions.nitrile);
      available.add(Functions.aldehyde);
    }

    if(_getFreeBonds() > 1) {
      available.add(Functions.ketone);
    }

    if(_getFreeBonds() > 0) {
      available.add(Functions.alcohol);
      available.add(Functions.amine);
      available.add(Functions.nitro);
      available.add(Functions.bromine);
      available.add(Functions.chlorine);
      available.add(Functions.fluorine);
      available.add(Functions.iodine);
      available.add(Functions.radical);
      available.add(Functions.hydrogen);
    }

    return available;
  }

  void bondSubstituent(Substituent substituent) => _chain.bond(substituent);

  void bondFunction(Functions function) =>
      bondSubstituent(Substituent(function));

  void bondCarbon() => _chain.bondCarbon();

  @override
  String toString() => _chain.toString();
}
