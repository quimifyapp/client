import 'package:cliente/constants.dart';
import 'package:cliente/pages/widgets/page_app_bar.dart';
import 'package:flutter/material.dart';

class OrganicImagePage extends StatelessWidget {
  OrganicImagePage({Key? key, required this.imageProvider}) : super(key: key);

  final ImageProvider imageProvider;
  final _transformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: quimifyGradientBoxDecoration,
      child: Scaffold(
        // To avoid keyboard resizing:
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const PageAppBar(title: 'Estructura'),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceTint,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                ),
                // To avoid rounded corners overflow:
                clipBehavior: Clip.hardEdge,
                child: GestureDetector(
                  onDoubleTap: () =>
                      _transformationController.value = Matrix4.identity(),
                  child: ColorFiltered(
                    colorFilter: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? identityFilter
                        : inverseFilter,
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
