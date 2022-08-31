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

bool isDigit(String char) {
  return digitToSubscript.containsKey(char) ||
      digitToSubscript.containsValue(char);
}

String toCapsAfterDigit(String input) {
  if (input.isEmpty) return input;

  String result = input[0];
  for (int i = 1; i < input.length; i++) {
    result += isDigit(input[i - 1]) ? input[i].toUpperCase() : input[i];
  }

  return result;
}

String toFirstCap(String input) {
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

String formatInorganicFormulaOrName(String formulaOrName) {
  return toSubscripts(toCapsAfterDigit(formulaOrName));
}

String formatOrganicName(String name) {
  return toCapsExceptN(name);
}

String formatFormula(String formula) {
  return toSubscripts(toCapsAfterDigit(toFirstCap(formula)));
}
