import 'package:collection/collection.dart';

RegExp inputFormatter = RegExp(r'[A-Za-zÁ-ú\d \(\),\-+'
    r'\u2080\u2081\u2082\u2083\u2084\u2085\u2086\u2087\u2088\u2089'
    r'\u207A\u207B]'); // Superscript + and -

RegExp formulaInputFormatter = RegExp(r'[A-IK-PR-Za-ik-pr-z\d\(\)'
    r'\u2080\u2081\u2082\u2083\u2084\u2085\u2086\u2087\u2088\u2089]');

RegExp equationInputFormatter = RegExp(r'[A-IK-PR-Za-ik-pr-z\d\(\)'
    r'\u2080\u2081\u2082\u2083\u2084\u2085\u2086\u2087\u2088\u2089\s\+]');

const Map<String, String> digitToSubscript = {
  '0': '\u2080',
  '1': '\u2081',
  '2': '\u2082',
  '3': '\u2083',
  '4': '\u2084',
  '5': '\u2085',
  '6': '\u2086',
  '7': '\u2087',
  '8': '\u2088',
  '9': '\u2089',
};

String toSubscripts(String input) {
  String result = '';

  for (int rune in input.runes) {
    String char = String.fromCharCode(rune);
    result += digitToSubscript[char] ?? char;
  }

  return result;
}

String toSubscriptsIfNotCoefficient(String input) {
  String result = '';
  bool isCoefficient = true; // Assume first number sequence is a coefficient
  bool inNumber = false; // Flag to track when we are within a number

  for (int i = 0; i < input.length; i++) {
    String char = input[i];
    if (char == ' ' || char == '+') {
      isCoefficient = true; // Reset for possible next coefficient
      result += char;
    } else if (RegExp(r'[0-9]').hasMatch(char)) {
      if (isCoefficient) {
        // If starting a number sequence after a space or at the start
        if (!inNumber) {
          inNumber = true;
          result += char; // Append the digit normally
        } else {
          result += char; // Continue appending digits of a coefficient
        }
      } else {
        result +=
            digitToSubscript[char]!; // Convert to subscript if not coefficient
      }
    } else {
      inNumber = false; // No longer in a number, reset flag
      isCoefficient =
          false; // Any non-space non-digit marks end of a coefficient
      result += char;
    }
  }

  return result;
}

bool isDigit(String char) =>
    digitToSubscript.containsKey(char) || digitToSubscript.containsValue(char);

String toSpacedPlusSign(String input) =>
    input.replaceAll(RegExp(r'(\s*\+\s*)+'), ' + ');

String noInitialAndFinalPlusSign(String input) =>
    input.replaceAll(RegExp(r'^\s*\+\s*|\s*\+\s*$'), '');

String noBlanksBetweenDigits(String input) =>
    input.replaceAll(RegExp(r'(?<=\d)\s+(?=\d)'), '');

String toCapsAfterDigitOrParentheses(String input) {
  if (input.isEmpty) return input;

  String result = input[0];
  for (int i = 1; i < input.length; i++) {
    result += isDigit(input[i - 1]) || RegExp('\\(|\\)').hasMatch(input[i - 1])
        ? input[i].toUpperCase()
        : input[i];
  }

  return result;
}

String capFirst(String input) {
  if (input.isEmpty) return input;

  String result = input[0].toUpperCase();

  for (int i = 1; i < input.length; i++) {
    result += input[i];
  }

  return result;
}

String toCapsExceptN(String input) {
  if (input.isEmpty) return input;

  String result = '';

  for (int i = 0; i < input.length; i++) {
    result += input[i] != 'N' ? input[i].toLowerCase() : input[i];
  }

  return result;
}

String toCapsAfterNotAnUppercaseLetter(String input) {
  if (input.isEmpty) return input;

  String result = input[0];
  for (int i = 1; i < input.length; i++) {
    result += input[i - 1] == input[i - 1].toUpperCase()
        ? input[i]
        : input[i].toUpperCase();
  }

  return result;
}

String toCapsAfterSpaceOrPlusSign(String input) {
  if (input.isEmpty) return input;

  String result = input[0];

  for (int i = 1; i < input.length; i++) {
    if (input[i - 1] == ' ' || input[i - 1] == '+') {
      result += input[i].toUpperCase();
    } else {
      result += input[i];
    }
  }

  return result;
}

String toDigits(String input) {
  String result = '';

  for (int rune in input.runes) {
    String char = String.fromCharCode(rune);

    String? digit = digitToSubscript.keys
        .firstWhereOrNull((key) => digitToSubscript[key] == char);

    if (digit != null) {
      result += digit;
    } else if (char == String.fromCharCode(0x207A)) {
      result += '+';
    } else if (char == String.fromCharCode(0x207B)) {
      result += '-';
    } else {
      result += char;
    }
  }

  return result;
}

String noInitialAndFinalBlanks(String input) {
  input = input.replaceAll(RegExp(r'^\s+'), ''); // Initial blanks
  return input.replaceAll(RegExp(r'\s+$'), ''); // Final blanks
}

String toSpacedBonds(String formula) {
  formula = formula.replaceAll(RegExp(r'-'), ' – ');
  formula = formula.replaceAll(RegExp(r'='), ' = ');
  return formula.replaceAll(RegExp(r'≡'), ' Ξ ');
}

String noBlanks(String input) => input.replaceAll(RegExp(r'\s+'), '');

bool isEmptyWithBlanks(String input) => noBlanks(input).isEmpty;

String formatMolecularMass(num mass) => mass.toStringAsFixed(2);

String formatInorganicFormulaOrName(String formulaOrName) =>
    toSubscripts(toCapsAfterDigitOrParentheses(
        formulaOrName.replaceAll('+', '⁺').replaceAll('-', '⁻')));

String formatFormula(String formula) => toCapsAfterNotAnUppercaseLetter(
    toSubscripts(toCapsAfterDigitOrParentheses((capFirst(formula)))));

String formatOrganicName(String name) => toCapsExceptN(name);

String formatStructureInput(String structure) =>
    toCapsAfterNotAnUppercaseLetter(
        formatInorganicFormulaOrName(capFirst(structure)));

String formatStructure(String structure) =>
    toSpacedBonds(toCapsAfterNotAnUppercaseLetter(
        toSubscripts(toCapsAfterDigitOrParentheses((capFirst(structure))))));

String formatEquationOngoingInput(String equation) =>
    capFirst(toCapsAfterSpaceOrPlusSign(toCapsAfterNotAnUppercaseLetter(
        toCapsAfterDigitOrParentheses(
            toSubscriptsIfNotCoefficient(equation)))));

String formatEquationInput(String input) =>
    noInitialAndFinalBlanks(toSubscriptsIfNotCoefficient(noBlanksBetweenDigits(
        toDigits(noInitialAndFinalPlusSign(toSpacedPlusSign(input))))));

String formatEquation(String equation) =>
    toSubscriptsIfNotCoefficient(equation);

String toEquation(String reactants, String products) =>
    '$products ⟶ $reactants';
