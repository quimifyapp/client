// lib/services/ocr_service.dart
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';

class OCRService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Extracts text from an image using Firebase Cloud Function
  Future<String?> extractTextFromImage(File imageFile) async {
    try {
      // Read the image file and convert to base64
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Call the Firebase function
      final HttpsCallable callable =
          _functions.httpsCallable('extractTextFromImage');
      final result = await callable.call({
        'imageBase64': base64Image,
      });

      if (result.data['success'] == true) {
        return result.data['text'];
      } else {
        throw Exception('Failed to extract text from image');
      }
    } catch (e) {
      log('Error extracting text: $e');
      rethrow;
    }
  }
}
