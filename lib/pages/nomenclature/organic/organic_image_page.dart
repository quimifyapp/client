import 'dart:math';

import 'package:cliente/pages/widgets/quimify_page_bar.dart';
import 'package:cliente/pages/widgets/quimify_scaffold.dart';
import 'package:cliente/pages/widgets/quimify_teal.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class OrganicImagePage extends StatefulWidget {
  const OrganicImagePage({Key? key, required this.imageProvider}) : super(key: key);

  final ImageProvider imageProvider;

  @override
  State<OrganicImagePage> createState() => _OrganicImagePageState();
}

class _OrganicImagePageState extends State<OrganicImagePage> {
  late PhotoViewControllerBase controller;
  late PhotoViewScaleStateController scaleStateController;

  @override
  void initState() {
    controller = PhotoViewController(initialScale: 1.0);
    scaleStateController = PhotoViewScaleStateController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    scaleStateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold(
      header: const QuimifyPageBar(title: 'Estructura'),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Stack(
          children: [
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.matrix(
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? [
                          247 / 245, 0, 0, 0, 0,
                          0, 247 / 245, 0, 0, 0,
                          0, 0, 247 / 245, 0, 0,
                          0, 0, 0, 1,
                          0, // Identity * [245 -> light background]
                        ]
                      : [
                          -237 / 245, 0, 0, 0, 255,
                          0, -237 / 245, 0, 0, 255,
                          0, 0, -237 / 245, 0, 255,
                          0, 0, 0, 1, 0, // Inverse * [245 -> dark background]
                        ],
                ),
                child: PhotoView(
                  imageProvider: widget.imageProvider,
                  controller: controller,
                  scaleStateController: scaleStateController,
                  disableGestures: true,
                  enableRotation: true,
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 15,
              right: 15,
              bottom: 40,
              child: StreamBuilder(
                stream: controller.outputStateStream,
                initialData: controller.value,
                builder: _streamBuild,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _streamBuild(BuildContext context, AsyncSnapshot snapshot) {
    const double minScale = 0.75;
    const double maxScale = 2.5;
    const double step = 0.5;

    final PhotoViewControllerValue value = snapshot.data;

    if (snapshot.hasError || !snapshot.hasData) {
      return Container();
    }

    void addToScale(double extraScale) {
      if (controller.scale != null) {
        double newScale = controller.scale! + extraScale;

        controller.scale =
            newScale < minScale ? minScale : min(newScale, maxScale);
      }
    }

    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => addToScale(-step),
          icon: const Icon(Icons.remove),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: quimifyTeal,
              thumbColor: quimifyTeal,
              inactiveTrackColor: Theme.of(context).colorScheme.secondary,
            ),
            child: Slider(
              value: value.scale!.clamp(minScale, maxScale),
              min: minScale,
              max: maxScale,
              onChanged: (double newScale) {
                controller.scale = newScale;
              },
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => addToScale(step),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
