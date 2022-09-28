import 'package:cliente/organic/components/functional_group.dart';
import 'package:cliente/organic/components/substituent.dart';
import 'package:cliente/organic/organic.dart';

abstract class OpenChain extends Organic {
  OpenChain getCopy();

  int getFreeBonds();

  bool isDone();

  List<FunctionalGroup> getOrderedBondableGroups();

  void bondCarbon();

  void bondSubstituent(Substituent substituent);

  void bondFunctionalGroup(FunctionalGroup function);

  String getStructure();
}
