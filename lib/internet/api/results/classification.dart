enum Classification {
  inorganicFormula,
  organicFormula,
  inorganicName,
  organicName,
  nomenclatureProblem,
  molecularMassProblem,
  chemicalProblem,
  chemicalReaction,
}

const Map<String, Classification> stringToClassification = {
  'inorganicFormula': Classification.inorganicFormula,
  'organicFormula': Classification.organicFormula,
  'inorganicName': Classification.inorganicName,
  'organicName': Classification.organicName,
  'nomenclatureProblem': Classification.nomenclatureProblem,
  'molecularMassProblem': Classification.molecularMassProblem,
  'chemicalProblem': Classification.chemicalProblem,
  'chemicalReaction': Classification.chemicalReaction,
};
