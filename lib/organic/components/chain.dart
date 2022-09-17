import 'package:cliente/organic/components/substituent.dart';

import '../organic.dart';
import 'carbon.dart';

class Chain extends Organic {
  Chain() {
    _carbons = [];
  }

  late List<Carbon> _carbons;

  void _start(int freeBonds) {
    _carbons.add(Carbon(freeBonds));
  }

  void bond(Substituent substituent) => _carbons.last.bond(substituent);

  void bondCarbon() {
    if (_carbons.isNotEmpty) {
      Carbon last = _carbons.last;
      last.bondCarbon();
      _carbons.add(Carbon(last.getFreeBonds() + 1));
    } else {
      _start(0);
    }
  }

  bool isDone() => getFreeBonds() == 0;

  int getFreeBonds() => _carbons.last.getFreeBonds();

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