import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardUser {
  final String userId;
  final String userName;
  final int points;
  final DateTime lastUpdated;
  final int? position;

  LeaderboardUser({
    required this.userId,
    required this.userName,
    required this.points,
    required this.lastUpdated,
    this.position,
  });

  factory LeaderboardUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LeaderboardUser(
      userId: doc.id,
      userName: data['userName'] as String,
      points: data['points'] as int,
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'points': points,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}
