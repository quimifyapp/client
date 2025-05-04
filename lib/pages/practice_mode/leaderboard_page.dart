import 'package:flutter/material.dart';
import 'package:quimify_client/internet/accounts/accounts.dart';
import 'package:quimify_client/internet/practice_mode/models/leaderboard_user.dart';
import 'package:quimify_client/internet/practice_mode/practice_mode.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<LeaderboardUser>? _users;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    try {
      final service = PracticeModeService();
      final users = await service.getLeaderboard();
      if (mounted) {
        setState(() {
          _users = users;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = context.l10n.errorLoadingLeaderboard;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold.noAd(
      header: QuimifyPageBar(title: context.l10n.ranking),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
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
                        context.l10n.topStudents,
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
                  const SizedBox(height: 12),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red))
                  else if (_users != null && _users!.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_users!.length > 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 72),
                            child: TopStudentBadge(
                              badgeUrl:
                                  'assets/images/practice_mode/2_place.png',
                              name: _users![1].userName,
                              score: _users![1].points,
                              size: 90,
                            ),
                          )
                        else
                          const SizedBox(),
                        if (_users!.isNotEmpty)
                          TopStudentBadge(
                            badgeUrl: 'assets/images/practice_mode/1_place.png',
                            name: _users![0].userName,
                            score: _users![0].points,
                          )
                        else
                          const SizedBox(),
                        if (_users!.length > 2)
                          Padding(
                            padding: const EdgeInsets.only(top: 72),
                            child: TopStudentBadge(
                              badgeUrl:
                                  'assets/images/practice_mode/3_place.png',
                              name: _users![2].userName,
                              score: _users![2].points,
                              size: 90,
                            ),
                          )
                        else
                          const SizedBox(),
                      ],
                    ),
                  const SizedBox(height: 24),
                  if (_users != null && _users!.length > 3) ..._buildUserList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildUserList() {
    final userService = AuthService();
    final currentUserId = userService.currentUser!.uid;

    final widgets = <Widget>[];
    final remainingUsers = _users!.sublist(3);

    for (var i = 0; i < remainingUsers.length; i++) {
      final user = remainingUsers[i];
      final previousPosition = i > 0 ? remainingUsers[i - 1].position ?? 0 : 3;
      final currentPosition = user.position ?? 0;

      // Add dots if there's a gap in positions
      if (currentPosition - previousPosition > 1) {
        widgets.add(
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 3; ++i)
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 52),
                        width: i % 2 == 0 ? 6 : 8,
                        height: i % 2 == 0 ? 6 : 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      widgets.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: 8,
            top: currentPosition - previousPosition > 1 ? 8 : 0,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[300]!,
              ),
            ),
            child: Row(
              children: [
                Text('$currentPosition'),
                const SizedBox(width: 12),
                Image.asset(
                  'assets/images/practice_mode/4_place.png',
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(user.userName +
                      (currentUserId == user.userId
                          ? ' (${context.l10n.you})'
                          : '')),
                ),
                Text(user.points.toString()),
              ],
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}

class TopStudentBadge extends StatelessWidget {
  const TopStudentBadge({
    super.key,
    required this.badgeUrl,
    required this.name,
    required this.score,
    this.size = 110,
  });

  final String badgeUrl;
  final String name;
  final int score;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: Column(
        children: [
          Image.asset(
            badgeUrl,
            width: size,
            height: size,
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            score.toString(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
