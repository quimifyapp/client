import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/internet/ocr/ocr_service.dart';
import 'package:quimify_client/pages/widgets/dialogs/loading_indicator.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/message_dialog.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

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
        // Crop the image
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: photo.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Recortar imagen',
              toolbarColor: QuimifyColors.teal(),
              toolbarWidgetColor: Colors.white,
              cropGridColor: QuimifyColors.teal(),
              cropFrameColor: QuimifyColors.teal(),
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              statusBarColor: QuimifyColors.teal(),
              hideBottomControls: false,
              showCropGrid: true,
              dimmedLayerColor: Colors.black.withOpacity(0.8),
              activeControlsWidgetColor: QuimifyColors.teal(),
            ),
            IOSUiSettings(
              title: 'Recortar imagen',
              doneButtonTitle: 'Hecho',
              cancelButtonTitle: 'Cancelar',
            ),
          ],
        );

        // If user cancelled cropping, exit early
        if (croppedFile == null) return;

        // Show loading indicator
        if (context.mounted) {
          showLoadingIndicator(context);
        }

        // Process the cropped image
        final file = File(croppedFile.path);
        final extractedText = await _ocrService.extractTextFromImage(file);

        // Hide loading indicator
        if (context.mounted) {
          hideLoadingIndicator();
        }

        if (extractedText != null) {
          onTextExtracted(extractedText);
        }
      }
    } catch (e) {
      // Hide loading indicator if visible
      if (context.mounted) {
        hideLoadingIndicator();
      }

      // Show error dialog
      if (context.mounted) {
        const MessageDialog(title: 'Error', details: 'No se puede procesar')
            .show(context);
      }
    }
  }
}
