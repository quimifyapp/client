// lib/widgets/camera_button_handler.dart
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/internet/ocr/ocr_service.dart';

class CameraButtonHandler {
  final OCRService _ocrService = OCRService();
  final ImagePicker _picker = ImagePicker();

  Future<void> handleCameraButton(
      BuildContext context, Function(String) onTextExtracted) async {
    try {
      // Capture image using camera
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (photo != null) {
        // Show loading indicator
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }

        // Process the image
        final file = File(photo.path);
        final extractedText = await _ocrService.extractTextFromImage(file);

        // Hide loading indicator
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        if (extractedText != null) {
          onTextExtracted(extractedText);
        }
      }
    } catch (e) {
      // Hide loading indicator if visible
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to process image: ${e.toString()}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
