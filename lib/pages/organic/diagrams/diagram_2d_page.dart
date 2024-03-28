import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';

class Diagram2DPage extends StatefulWidget {
  const Diagram2DPage({
    Key? key,
    required this.imageProvider,
  }) : super(key: key);

  final ImageProvider imageProvider;

  @override
  State<Diagram2DPage> createState() => _Diagram2DPageState();
}

class _Diagram2DPageState extends State<Diagram2DPage> {
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
    Color from = const Color.fromARGB(255, 245, 245, 245);
    Color to = QuimifyColors.background(context);

    return QuimifyScaffold.noAd(
      header: const QuimifyPageBar(title: 'Estructura'),
      body: Container(
        color: QuimifyColors.background(context),
        child: Stack(
          children: [
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.matrix(
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? [
                          to.red / from.red, 0, 0, 0, 0,
                          0, to.green / from.green, 0, 0, 0,
                          0, 0, to.blue / from.blue, 0, 0,
                          0, 0, 0, 1, 0, // [from -> to]
                        ]
                      : [
                          (to.red - 255) / from.red, 0, 0, 0, 255,
                          0, (to.green - 255) / from.green, 0, 0, 255,
                          0, 0, (to.blue - 255) / from.blue, 0, 255,
                          0, 0, 0, 1, 0, // [[from -> inverse] -> to]
                        ],
                ),
                child: PhotoView(
                  imageProvider: widget.imageProvider,
                  controller: controller,
                  scaleStateController: scaleStateController,
                  enableRotation: true,
                  backgroundDecoration: const BoxDecoration(),
                  // Needed
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
              activeTrackColor: QuimifyColors.teal(),
              thumbColor: QuimifyColors.teal(),
              inactiveTrackColor: QuimifyColors.tertiary(context),
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
