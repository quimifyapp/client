import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quimify_client/internet/practice_mode/models/answer.dart';
import 'package:quimify_client/internet/practice_mode/models/question.dart';
import 'package:quimify_client/internet/practice_mode/practice_mode.dart';
import 'package:quimify_client/pages/practice_mode/leaderboard_page.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.difficulty, required this.category});

  final String difficulty;
  final String category;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  PageController? _pageController;
  List<Question> _questions = [];
  List<Answer> _answers = [];
  bool isLoading = true;
  Timer? _timer;
  int _timeLeft = 30;
  bool _answerSelected = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController?.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _timeLeft = 30;
      _answerSelected = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _moveToNextQuestion();
      }
    });
  }

  void _moveToNextQuestion() {
    _timer?.cancel();
    if (_pageController?.page?.toInt() == _questions.length - 1) {
      // Submit quiz and navigate to leaderboard
      _submitQuizAndShowLeaderboard();
      return;
    }

    if (mounted) {
      setState(() {
        _answers.add(Answer(
          option: '',
          question: _questions[_pageController?.page?.toInt() ?? 0],
        ));
      });

      _pageController
          ?.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          )
          .then((_) => _startTimer());
    }
  }

  Future<void> _loadQuestions() async {
    final service = PracticeModeService();
    final questions = await service.createQuiz(
      difficulty: widget.difficulty,
      category: widget.category,
    );
    log(questions.length.toString());
    setState(() {
      _questions = questions;
      isLoading = false;
    });
    _startTimer();
  }

  Future<void> _submitQuizAndShowLeaderboard() async {
    try {
      final service = PracticeModeService();
      await service.submitQuizResults(answers: _answers);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LeaderboardPage(),
          ),
        );
      }
    } catch (e) {
      log('Error submitting quiz: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error submitting quiz results'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold.noAd(
      header: QuimifyPageBar(
        leading: Image.asset(
          'assets/images/atomic.png',
          height: 72,
        ),
        trailing: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/images/practice_mode/timer.png', height: 72),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${_timeLeft}s',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: QuimifyColors.background(context),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                const SizedBox(height: 12),
                // Question box:
                if (isLoading || _questions.isEmpty)
                  const CircularProgressIndicator()
                else
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children: _questions.map((question) {
                        return Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.height *
                                            0.2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: QuimifyColors.background(context),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Center(
                                    child: Text(
                                      question.question,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                if (_pageController?.hasClients ?? false)
                                  Positioned(
                                    top: 16,
                                    left: 16,
                                    child: Text(
                                      'Pregunta ${(_pageController?.page?.toInt() ?? 0) + 1} / ${_questions.length}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            // Answer options:
                            const SizedBox(height: 32),
                            ...question.options.map((option) {
                              return QuestionOption(
                                option: option.value,
                                isCorrect: question.solution == option.id,
                                enabled: !_answerSelected,
                                onTap: () async {
                                  if (_answerSelected) return;
                                  setState(() => _answerSelected = true);
                                  _timer
                                      ?.cancel(); // Stop timer when answer selected

                                  // Wait for animation before proceeding
                                  await Future.delayed(
                                      const Duration(seconds: 2));

                                  if (mounted) {
                                    setState(() {
                                      _answers.add(Answer(
                                        option: option.id,
                                        question: question,
                                      ));
                                    });

                                    // Check if this is the last question
                                    if (_pageController?.page?.toInt() ==
                                        _questions.length - 1) {
                                      _submitQuizAndShowLeaderboard();
                                    } else {
                                      _pageController
                                          ?.nextPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          )
                                          .then((_) => _startTimer());
                                    }
                                  }
                                },
                              );
                            }).toList(),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionOption extends StatefulWidget {
  const QuestionOption({
    super.key,
    required this.option,
    required this.isCorrect,
    required this.onTap,
    required this.enabled,
  });

  final String option;
  final bool isCorrect;
  final VoidCallback onTap;
  final bool enabled;

  @override
  State<QuestionOption> createState() => _QuestionOptionState();
}

class _QuestionOptionState extends State<QuestionOption> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    if (_isSelected) {
      backgroundColor = widget.isCorrect ? Colors.green[100] : Colors.red[100];
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Opacity(
        opacity: widget.enabled ? 1.0 : 0.6,
        child: GestureDetector(
          onTap: widget.enabled
              ? () {
                  if (!_isSelected) {
                    setState(() => _isSelected = true);
                    widget.onTap();
                  }
                }
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            width: double.infinity,
            decoration: BoxDecoration(
              color: backgroundColor ?? QuimifyColors.background(context),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isSelected
                    ? (widget.isCorrect ? Colors.green : Colors.red)
                    : Colors.grey[300]!,
              ),
            ),
            child: Text(
              widget.option,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _isSelected
                    ? (widget.isCorrect ? Colors.green[900] : Colors.red[900])
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
