import 'package:cliente/organic/components/functions.dart';
import 'package:cliente/organic/organic.dart';

abstract class OpenChain extends Organic {
  OpenChain getCopy();

  int getFreeBonds();

  bool isDone();

  List<Functions> getBondableFunctions();

  void bondCarbon();

  void bondFunction(Functions function);

  String getFormula();
}