import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatMessageModel {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String status;

  ChatMessageModel({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    required this.status,
  });

  factory ChatMessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessageModel(
      id: doc.id,
      content: data['content'] ?? '',
      isUser: data['isUser'] ?? false,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      status: data['status'] ?? 'delivered',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'isUser': isUser,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status,
    };
  }
}

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _messagesRef =>
      _firestore.collection('chatbot').doc(_userId).collection('messages');

  // Stream messages with welcome message always first
  Stream<List<ChatMessageModel>> streamMessages() async* {
    yield* _messagesRef
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      final messages = snapshot.docs
          .map((doc) => ChatMessageModel.fromFirestore(doc))
          .toList();

      // Sort messages by timestamp, keeping welcome message first
      messages.sort((a, b) {
        if (a.id == 'welcome') return -1;
        if (b.id == 'welcome') return 1;
        return a.timestamp.compareTo(b.timestamp);
      });

      return messages;
    });
  }

  // Send message
  Future<String> sendMessage(String message) async {
    try {
      final callable = _functions.httpsCallable('processChat');
      final result = await callable.call({
        'message': message,
      });

      if (result.data['success']) {
        return result.data['messageId'];
      } else {
        throw Exception('Failed to process message');
      }
    } on FirebaseFunctionsException catch (e) {
      throw Exception('Firebase function error: ${e.message}');
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  // Get message by ID
  Future<ChatMessageModel?> getMessage(String messageId) async {
    try {
      final doc = await _messagesRef.doc(messageId).get();
      return doc.exists ? ChatMessageModel.fromFirestore(doc) : null;
    } catch (e) {
      throw Exception('Error fetching message: $e');
    }
  }

  // Clear chat history but keep welcome message
  Future<void> clearHistory() async {
    try {
      final messages = await _messagesRef.where(FieldPath.documentId).get();

      final batch = _firestore.batch();
      for (var doc in messages.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Error clearing chat history: $e');
    }
  }
}
