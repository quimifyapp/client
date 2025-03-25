import 'dart:convert';
import 'dart:developer' as dev;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:quimify_client/internet/accounts/accounts.dart';
import 'models/question.dart';
import 'models/answer.dart';
import 'models/leaderboard_user.dart';

class PracticeModeService {
  List<Question>? _questions;
  // Adjust max questions the user can answer during a quiz
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
            dev.log('Error parsing row $i: $e');
            // Skip invalid rows instead of failing completely
            continue;
          }
        }
      }
      dev.log('Questions loaded successfully: ${_questions!.length} questions');
    } catch (e, stackTrace) {
      dev.log('Error loading questions: $e');
      dev.log('Stack trace: $stackTrace');
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

    final filtered = _questions!
        .where((q) =>
            q.difficulty == difficulty.toLowerCase() &&
            q.category == category.toLowerCase())
        .toList();

    // Randomize questions
    filtered.shuffle();
    return filtered.take(_maxQuestions).toList();
  }

  Future<Map<String, dynamic>> submitQuizResults({
    required List<Answer> answers,
  }) async {
    try {
      final authService = AuthService();

      // Convert answers to the format expected by the cloud function
      final formattedAnswers = answers
          .map((answer) => {
                'id': answer.question.id,
                'answer': answer.option,
              })
          .toList();

      // Call the cloud function
      final result = await FirebaseFunctions.instance
          .httpsCallable('processPracticeModeAnswers')
          .call({
        'answers': formattedAnswers,
        'userName': authService.firstName ?? 'N/A',
      });

      return result.data as Map<String, dynamic>;
    } catch (e) {
      dev.log('Error submitting quiz results: $e');
      rethrow;
    }
  }

  Future<List<LeaderboardUser>> getLeaderboard() async {
    try {
      final authService = AuthService();
      final userId = authService.currentUser!.uid;

      // Get top 10 users
      final QuerySnapshot topSnapshot = await FirebaseFirestore.instance
          .collection('leaderboard')
          .orderBy('points', descending: true)
          .limit(10)
          .get();

      final topUsers = topSnapshot.docs
          .map((doc) => LeaderboardUser.fromFirestore(doc))
          .toList();

      // Check if current user is in top 10
      final isUserInTop10 = topUsers.any((user) => user.userId == userId);

      if (!isUserInTop10) {
        // Get current user's position by counting users with higher points
        final userDoc = await FirebaseFirestore.instance
            .collection('leaderboard')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          final userPoints = userData['points'] as int;

          // Count users with higher points to get position
          final AggregateQuerySnapshot higherPointsQuery =
              await FirebaseFirestore.instance
                  .collection('leaderboard')
                  .where('points', isGreaterThan: userPoints)
                  .count()
                  .get();

          final position = (higherPointsQuery.count ?? 0) + 1;

          // Add current user to the list with their position
          final currentUser = LeaderboardUser.fromFirestore(userDoc);
          topUsers.add(LeaderboardUser(
            userId: currentUser.userId,
            userName: currentUser.userName,
            points: currentUser.points,
            lastUpdated: currentUser.lastUpdated,
            position: position,
          ));
        }
      }

      // Set positions for top 10
      for (var i = 0; i < topUsers.length; i++) {
        if (i < 10) {
          topUsers[i] = LeaderboardUser(
            userId: topUsers[i].userId,
            userName: topUsers[i].userName,
            points: topUsers[i].points,
            lastUpdated: topUsers[i].lastUpdated,
            position: i + 1,
          );
        }
      }

      return topUsers;
    } catch (e) {
      dev.log('Error fetching leaderboard: $e');
      rethrow;
    }
  }
}
