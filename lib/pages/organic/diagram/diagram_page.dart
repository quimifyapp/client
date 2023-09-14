import 'dart:math';
import 'package:quimify_client/pages/widgets/appearance/quimify_teal.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DiagramPage extends StatefulWidget {
  const DiagramPage({
    Key? key,
    required this.imageProvider,
  }) : super(key: key);

  final ImageProvider imageProvider;

  @override
  State<DiagramPage> createState() => _DiagramPageState();
}

class _DiagramPageState extends State<DiagramPage> {
  late PhotoViewControllerBase controller;
  late PhotoViewScaleStateController scaleStateController;

  static const double minScale = 0.75;
  static const double maxScale = 2.5;
  static const double step = 0.5;

  @override
  initState() {
    super.initState();

    controller = PhotoViewController(initialScale: 1.0);
    scaleStateController = PhotoViewScaleStateController();
  }

  @override
  dispose() {
    controller.dispose();
    scaleStateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold(
      showBannerAd: false,
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
                          0, 0, 0, 1, 0, // Identity * [245 -> light background]
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
                  enableRotation: true,
                  backgroundDecoration: const BoxDecoration(), // Needed
                  // TODO bug:
                  disableGestures: true,
                  //minScale: 0.75,
                  //maxScale: 2.5,
                  //filterQuality: FilterQuality.high,
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 15,
              right: 15,
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

  addToScale(double extraScale) {
    if (controller.scale != null) {
      double newScale = controller.scale! + extraScale;

      controller.scale =
          newScale < minScale ? minScale : min(newScale, maxScale);
    }
  }

  Widget _streamBuild(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasError || !snapshot.hasData) {
      return Container();
    }

    final PhotoViewControllerValue value = snapshot.data;

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
