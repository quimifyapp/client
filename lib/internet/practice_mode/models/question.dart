class Option {
  final String id;
  final String value;

  const Option({required this.id, required this.value});
}

class Question {
  final String id;
  final String question;
  final List<Option> options;
  final String solution;
  final String category;
  final String difficulty;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.solution,
    required this.category,
    required this.difficulty,
  });

  factory Question.fromCsv(List<dynamic> row) {
    return Question(
      id: row[0],
      question: row[1],
      options: [
        Option(id: 'A', value: row[2]),
        Option(id: 'B', value: row[3]),
        Option(id: 'C', value: row[4]),
        Option(id: 'D', value: row[5]),
      ],
      solution: row[6],
      category: row[7],
      difficulty: row[8],
    );
  }
}
