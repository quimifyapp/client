import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/internet/ads/ads.dart';
import 'package:quimify_client/internet/payments/payments.dart';
import 'package:quimify_client/pages/practice_mode/quiz_page.dart';
import 'package:quimify_client/pages/practice_mode/selection_button.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

import '../widgets/dialogs/messages/message_dialog.dart';
import '../widgets/dialogs/messages/no_internet_dialog.dart';

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
      header: QuimifyPageBar(title: context.l10n.practice),
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
                        context.l10n.categories,
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
                                title: context.l10n.general,
                                imageUr:
                                    'assets/images/practice_mode/category_general.png',
                                onTap: () async {
                                  // Check internet connectivity before proceeding
                                  final connectivityResult =
                                      await Connectivity().checkConnectivity();
                                  if (connectivityResult ==
                                      ConnectivityResult.none) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          noInternetDialog(context),
                                    );
                                    return;
                                  }
                                  final ads = Ads();
                                  final payments = Payments();
                                  // If user is subscribed, navigate to quiz
                                  if (payments.isSubscribed) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizPage(
                                          difficulty: difficulty,
                                          category: 'general',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  // If user can watch rewarded ad, show it
                                  if (ads.canWatchPracticeModeRewardedAd) {
                                    if (!context.mounted) return;
                                    await MessageDialog(
                                      title: context.l10n.playPractice,
                                      details:
                                          context.l10n.playPracticeDescription,
                                      onButtonPressed: () async {
                                        final watched = await ads
                                            .showRewardedPracticeMode();
                                        if (watched && context.mounted) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => QuizPage(
                                                difficulty: difficulty,
                                                category: 'general',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ).show(context);
                                    return;
                                  }

                                  // If user cannot watch rewarded ad, show limit reached message
                                  if (!context.mounted) return;
                                  await MessageDialog(
                                    title: context.l10n.dailyMaximumReached,
                                    details: context.l10n
                                        .playPracticeLimitReachedDescription,
                                  ).show(context);
                                },
                              ),
                              const SizedBox(width: 72),
                              SelectionButton(
                                title: context.l10n.balancing,
                                imageUr:
                                    'assets/images/practice_mode/category_balancing.png',
                                onTap: () async {
                                  final payments = Payments();
                                  if (payments.isSubscribed) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizPage(
                                          difficulty: difficulty,
                                          category: 'balancing',
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
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SelectionButton(
                                title: context.l10n.inorganic,
                                imageUr:
                                    'assets/images/practice_mode/category_inorganic.png',
                                onTap: () async {
                                  final payments = Payments();
                                  if (payments.isSubscribed) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizPage(
                                          difficulty: difficulty,
                                          category: 'inorganic',
                                        ),
                                      ),
                                    );
                                  } else {
                                    await payments.showPaywall(context);
                                  }
                                },
                              ),
                              const SizedBox(width: 72),
                              SelectionButton(
                                title: context.l10n.organic,
                                imageUr:
                                    'assets/images/practice_mode/category_organic.png',
                                onTap: () async {
                                  final payments = Payments();
                                  if (payments.isSubscribed) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizPage(
                                          difficulty: difficulty,
                                          category: 'organic',
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
                          const SizedBox(height: 40),
                          SelectionButton(
                            title: context.l10n.university,
                            imageUr:
                                'assets/images/practice_mode/category_university.png',
                            onTap: () async {
                              final payments = Payments();

                              if (payments.isSubscribed) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizPage(
                                      difficulty: difficulty,
                                      category: 'university',
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
