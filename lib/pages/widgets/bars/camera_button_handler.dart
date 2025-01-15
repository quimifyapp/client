import 'dart:io';
import 'dart:ui';

import 'package:crop_image/crop_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:quimify_client/internet/ocr/ocr_service.dart';
import 'package:quimify_client/internet/payments/payments.dart';
import 'package:quimify_client/pages/widgets/dialogs/loading_indicator.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/message_dialog.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class CameraButtonHandler {
  final OCRService _ocrService = OCRService();
  final ImagePicker _picker = ImagePicker();

  Future<void> handleCameraButton(
      BuildContext context, Function(String) onTextExtracted) async {
    try {
      // Show source selection dialog
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => const ImageSourceDialog(),
      );

      // If user cancelled selection, exit early
      if (source == null) return;

      // Capture image using selected source
      final XFile? photo = await _picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (photo != null && context.mounted) {
        // Show the cropping screen
        final croppedFile = await Navigator.of(context).push<File>(
          MaterialPageRoute(
            builder: (context) =>
                ImageCropperScreen(imageFile: File(photo.path)),
          ),
        );

        // If user cancelled cropping, exit early
        if (croppedFile == null) return;

        // Show loading indicator
        if (context.mounted) {
          showLoadingIndicator(context);
        }

        // Check if user has subscribed to premium
        if (!Payments().isSubscribed) {
          // Show paywall
          await Payments().showPaywall();

          // Exit early if user has not subscribed
          if (!Payments().isSubscribed) {
            // Hide loading indicator
            if (context.mounted) {
              hideLoadingIndicator();
            }
            return;
          }
        }

        // Process the cropped image
        final extractedText =
            await _ocrService.extractTextFromImage(croppedFile);

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

class ImageCropperScreen extends StatefulWidget {
  final File imageFile;

  const ImageCropperScreen({Key? key, required this.imageFile})
      : super(key: key);

  @override
  State<ImageCropperScreen> createState() => _ImageCropperScreenState();
}

class _ImageCropperScreenState extends State<ImageCropperScreen> {
  final controller = CropController();
  bool _isCropping = false;

  Future<void> _cropImage() async {
    if (_isCropping) return;
    setState(() => _isCropping = true);

    try {
      // Get the cropped image
      final image = await controller.croppedBitmap();

      // Save image to temp file
      final tempDir = await Directory.systemTemp.create(recursive: true);
      final tempFile = File(
          '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg');

      final bytes = await image.toByteData(format: ImageByteFormat.png);

      await tempFile.writeAsBytes(bytes!.buffer.asUint8List());

      if (mounted) {
        Navigator.of(context).pop(tempFile);
      }
    } finally {
      if (mounted) {
        setState(() => _isCropping = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: QuimifyColors.teal(),
        title: const Text('Recortar imagen'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isCropping)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _cropImage,
            ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: CropImage(
                controller: controller,
                image: Image.file(widget.imageFile),
                gridColor: QuimifyColors.teal(),
                gridCornerSize: 25,
                gridThinWidth: 1,
                gridThickWidth: 2,
                alwaysShowThirdLines: true,
              ),
            ),
          ),
          if (_isCropping)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ImageSourceDialog extends StatelessWidget {
  const ImageSourceDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Seleccionar imagen',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SourceOption(
                  icon: Icons.camera_alt,
                  label: 'Cámara',
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                _SourceOption(
                  icon: Icons.photo_library,
                  label: 'Galería',
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: QuimifyColors.teal()),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: QuimifyColors.teal(),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
