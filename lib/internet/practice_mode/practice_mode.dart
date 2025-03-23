import 'dart:convert';
import 'dart:developer';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'models/question.dart';

class PracticeModeService {
  List<Question>? _questions;
  final int _maxQuestions = 10;

  Future<void> loadQuestions() async {
    if (_questions != null) return;

    try {
      // Get the ByteData and decode with UTF8
      final ByteData fileData =
          await rootBundle.load('assets/csv/practice_mode_spanish.csv');
      final String rawData = utf8.decode(
        fileData.buffer
            .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes),
        allowMalformed: true,
      );

      // Clean data if needed
      String cleanData = rawData.replaceAll('Â', '');

      // Parse CSV
      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(cleanData);

      // Get headers for validation
      final headers = csvTable[0].map((e) => e.toString().trim()).toList();
      final expectedHeaders = [
        'id',
        'question',
        'A',
        'B',
        'C',
        'D',
        'solution',
        'category',
        'difficulty'
      ];

      // Validate headers
      if (!_areHeadersValid(headers, expectedHeaders)) {
        throw Exception('Invalid CSV format: missing required columns');
      }

      // Convert to Question objects with validation
      _questions = [];
      for (var i = 1; i < csvTable.length; i++) {
        if (csvTable[i].length == headers.length) {
          try {
            final row = csvTable[i].map((e) => e.toString().trim()).toList();
            _questions!.add(Question.fromCsv(row));
          } catch (e) {
            log('Error parsing row $i: $e');
            // Skip invalid rows instead of failing completely
            continue;
          }
        }
      }
      log('Questions loaded successfully: ${_questions!.length} questions');
    } catch (e, stackTrace) {
      log('Error loading questions: $e');
      log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  bool _areHeadersValid(List<String> actual, List<String> expected) {
    return expected.every((header) => actual.contains(header));
  }

  Future<List<Question>> createQuiz({
    required String difficulty,
    required String category,
    String language = 'es',
  }) async {
    if (_questions == null) {
      await loadQuestions();
    }

    return _questions!
        .where((q) =>
            q.difficulty == difficulty.toLowerCase() &&
            q.category == category.toLowerCase())
        .toList()
        .take(_maxQuestions)
        .toList();
  }
}
