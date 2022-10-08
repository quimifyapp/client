import 'package:quimify_client/organic/components/functional_group.dart';
import 'package:quimify_client/organic/components/substituent.dart';
import 'package:quimify_client/organic/organic.dart';

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
