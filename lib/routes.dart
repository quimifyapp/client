import 'package:quimify_client/internet/api/results/classification.dart';

class Routes {
  static const String inorganicNomenclature = 'inorganic/nomenclature';
  static const String organicNaming = 'organic/naming';
  static const String organicFindingFormula = 'organic/finding-formula';
  static const String calculatorMolecularMass = 'calculator/molecular-mass';
  static const String calculatorEquation = 'calculator/equation';

  static final Map<Classification, String> fromClassification = {
    Classification.inorganicFormula: inorganicNomenclature,
    Classification.organicFormula: organicNaming,
    Classification.inorganicName: inorganicNomenclature,
    Classification.organicName: organicFindingFormula,
    Classification.molecularMassProblem: calculatorMolecularMass,
    Classification.chemicalReaction: calculatorEquation
  };

  static bool contains(Classification classification) =>
      fromClassification.keys.contains(classification);
}
