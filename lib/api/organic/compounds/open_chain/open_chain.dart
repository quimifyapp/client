import 'package:quimify_client/api/organic/components/functional_group.dart';
import 'package:quimify_client/api/organic/components/substituent.dart';
import 'package:quimify_client/api/organic/organic.dart';

abstract class OpenChain extends Organic {
  OpenChain getCopy();

  int getFreeBonds();

  bool isDone();

  bool canBondCarbon();

  void bondCarbon();

  void bondSubstituent(Substituent substituent);

  void bondFunctionalGroup(FunctionalGroup function);

  List<FunctionalGroup> getOrderedBondableGroups();

  String getStructure();
}
