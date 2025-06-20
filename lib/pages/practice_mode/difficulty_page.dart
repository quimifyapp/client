import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/internet/payments/payments.dart';
import 'package:quimify_client/pages/practice_mode/category_page.dart';
import 'package:quimify_client/pages/practice_mode/leaderboard_page.dart';
import 'package:quimify_client/pages/practice_mode/selection_button.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

import '../widgets/dialogs/messages/no_internet_dialog.dart';

class DifficultyPage extends StatelessWidget {
  const DifficultyPage({super.key});

  Widget _buildDots() {
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

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold.noAd(
      header: QuimifyPageBar(title: context.l10n.practice),
      fab: FloatingActionButton(
        backgroundColor: QuimifyColors.teal(),
        onPressed: () async {
          // Check internet connectivity before proceeding
          final connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none) {
            showDialog(
              context: context,
              builder: (BuildContext context) => noInternetDialog(context),
            );
            return;
          }
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LeaderboardPage()));
        },
        child: const Icon(Icons.leaderboard),
      ),
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
                        context.l10n.difficulty,
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
                          SelectionButton(
                            title: context.l10n.easy,
                            imageUr:
                                'assets/images/practice_mode/difficulty_easy.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CategoryPage(
                                    difficulty: 'easy',
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SelectionButton(
                                title: context.l10n.medium,
                                imageUr:
                                    'assets/images/practice_mode/difficulty_medium.png',
                                onTap: () async {
                                  final payments = Payments();
                                  if (payments.isSubscribed) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CategoryPage(
                                          difficulty: 'medium',
                                        ),
                                      ),
                                    );
                                  } else {
                                    await payments.showPaywall(context);
                                  }
                                },
                              ),
                              const SizedBox(width: 40),
                              SelectionButton(
                                title: context.l10n.expert,
                                imageUr:
                                    'assets/images/practice_mode/difficulty_difficult.png',
                                onTap: () async {
                                  final payments = Payments();
                                  if (payments.isSubscribed) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CategoryPage(
                                          difficulty: 'hard',
                                        ),
                                      ),
                                    );
                                  } else {
                                    await payments.showPaywall(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Left dots trail
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.16,
                        left: MediaQuery.of(context).size.width * 0.20,
                        child: Transform.rotate(
                          angle: -0.9,
                          child: _buildDots(),
                        ),
                      ),
                      // Right dots trail
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.25,
                        right: MediaQuery.of(context).size.width * 0.40,
                        child: Transform.rotate(
                          angle: 0.3,
                          child: _buildDots(),
                        ),
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
