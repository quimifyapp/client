import 'package:flutter/material.dart';
import 'package:quimify_client/pages/practice_mode/quiz_page.dart';
import 'package:quimify_client/pages/practice_mode/selection_button.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key, required this.difficulty});

  final String difficulty;

  Widget _buildDotsHorizontal() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Transform.translate(
            offset: const Offset(0, -8),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  // Create dots trail for diagonal right to left
  Widget _buildDotsDiagonal() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Transform.translate(
            offset: const Offset(4, -10),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -32),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  // Create dots trail for diagonal right to left
  Widget _buildDotsDiagonal2() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.translate(
          offset: const Offset(24, 22),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Transform.translate(
            offset: const Offset(4, -10),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -32),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold.noAd(
      header: const QuimifyPageBar(title: 'Practicar'),
      body: SingleChildScrollView(
        child: Column(
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
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Categorías',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Stack(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SelectionButton(
                                title: 'General',
                                imageUr:
                                    'assets/images/practice_mode/category_general.png',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizPage(
                                        difficulty: difficulty,
                                        category: 'general',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 72),
                              SelectionButton(
                                title: 'Equilibrio',
                                imageUr:
                                    'assets/images/practice_mode/category_balancing.png',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizPage(
                                        difficulty: difficulty,
                                        category: 'balancing',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SelectionButton(
                                title: 'Inorgánico',
                                imageUr:
                                    'assets/images/practice_mode/category_inorganic.png',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizPage(
                                        difficulty: difficulty,
                                        category: 'inorganic',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 72),
                              SelectionButton(
                                title: 'Organico',
                                imageUr:
                                    'assets/images/practice_mode/category_organic.png',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizPage(
                                        difficulty: difficulty,
                                        category: 'organic',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          SelectionButton(
                            title: 'Universidad',
                            imageUr:
                                'assets/images/practice_mode/category_university.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizPage(
                                    difficulty: difficulty,
                                    category: 'university',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      // Left dots trail
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.1,
                        left: MediaQuery.of(context).size.width * 0.39,
                        child: _buildDotsHorizontal(),
                      ),
                      // Right dots trail
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.23,
                        right: MediaQuery.of(context).size.width * 0.39,
                        child: _buildDotsDiagonal(),
                      ),
                      // Bottom dots trail
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.32,
                        left: MediaQuery.of(context).size.width * 0.39,
                        child: _buildDotsHorizontal(),
                      ),
                      // Bottom dots trail
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.22,
                        right: MediaQuery.of(context).size.width * 0.39,
                        child: _buildDotsDiagonal2(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
