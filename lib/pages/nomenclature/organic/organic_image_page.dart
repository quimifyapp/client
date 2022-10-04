import 'package:cliente/pages/widgets/quimify_page_bar.dart';
import 'package:cliente/pages/widgets/quimify_scaffold.dart';
import 'package:flutter/material.dart';

class OrganicImagePage extends StatelessWidget {
  OrganicImagePage({Key? key, required this.imageProvider}) : super(key: key);

  final ImageProvider imageProvider;
  final _transformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold(
      header: const QuimifyPageBar(title: 'Estructura'),
      body: GestureDetector(
        onDoubleTap: () => _transformationController.value = Matrix4.identity(),
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
          child: InteractiveViewer(
            transformationController: _transformationController,
            child: Image(
              image: imageProvider,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
