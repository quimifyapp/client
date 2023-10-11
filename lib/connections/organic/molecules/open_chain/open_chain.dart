import 'package:quimify_client/connections/organic/components/group.dart';
import 'package:quimify_client/connections/organic/components/substituent.dart';
import 'package:quimify_client/connections/organic/organic.dart';

abstract class OpenChain extends Organic {
  bool isDone();

  int getFreeBondCount();

  List<Group> getBondableGroups();

  OpenChain bondSubstituent(Substituent substituent);

  OpenChain bondGroup(Group function);

  bool canBondCarbon();

  bondCarbon();

  String getStructure();

  OpenChain getCopy();
}
