import 'package:quimify_client/pages/organic/diagram/diagram_page.dart';
import 'package:quimify_client/pages/organic/widgets/organic_result_field.dart';
import 'package:quimify_client/pages/organic/widgets/structure_help_dialog.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_help_button.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_coming_soon_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_report_dialog.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class OrganicResultView extends StatelessWidget {
  const OrganicResultView({
    Key? key,
    this.scrollController,
    required this.fields,
    required this.imageProvider,
    required this.quimifyReportDialog,
  }) : super(key: key);

  final ScrollController? scrollController;
  final Map<String, String> fields;
  final ImageProvider? imageProvider;
  final QuimifyReportDialog quimifyReportDialog;

  void _pressedReportButton(BuildContext context) =>
      quimifyReportDialog.show(context);

  void _pressedShareButton(BuildContext context) =>
      quimifyComingSoonDialog.showIn(context);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController ?? ScrollController(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Resultado',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              QuimifyIconButton.square(
                height: 44,
                backgroundColor: Theme.of(context).colorScheme.error,
                onPressed: () => _pressedReportButton(context),
                icon: Image.asset(
                  'assets/images/icons/report.png',
                  color: Theme.of(context).colorScheme.onError,
                  width: 18,
                ),
              ),
              const SizedBox(width: 12),
              QuimifyIconButton.square(
                height: 44,
                onPressed: () => _pressedShareButton(context),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                icon: Icon(
                  Icons.share_outlined,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(20),
            child: Wrap(
              runSpacing: 13,
              children: fields.entries
                  .map(
                    (field) => OrganicResultField(
                      title: field.key,
                      field: field.value,
                    ),
                  )
                  .toList(),
            ),
          ),
          if (imageProvider != null) ...[
            const SizedBox(height: 20),
            Text(
              'Estructura',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),
            Stack(
              children: [
                // Top buttons:
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: HelpButton(
                          dialog: StructureHelpDialog(),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        // To remove padding:
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return DiagramPage(
                                imageProvider: imageProvider!,
                              );
                            },
                          ),
                        ),
                        icon: Icon(
                          size: 30,
                          color: Theme.of(context).colorScheme.primary,
                          Icons.fullscreen_rounded,
                        ),
                      ),
                      const SizedBox(width: 5), // So it feels symmetrical
                    ],
                  ),
                ),
                // Picture:
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    // Diagram background:
                    color: Theme.of(context).colorScheme.surfaceTint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // To avoid rounded corners overflow:
                  clipBehavior: Clip.hardEdge,
                  child: ColorFiltered(
                    colorFilter: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? const ColorFilter.matrix(
                            [
                              255 / 245, 0, 0, 0, 0, //
                              0, 255 / 245, 0, 0, 0, //
                              0, 0, 255 / 245, 0, 0, //
                              0, 0, 0, 1, 0, //
                            ],
                          )
                        : const ColorFilter.matrix(
                            [
                              -1, 0, 0, 0, 255, //
                              0, -1, 0, 0, 255, //
                              0, 0, -1, 0, 255, //
                              0, 0, 0, 1, 0, //
                            ],
                          ),
                    child: PhotoView(
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      initialScale: 1.0,
                      gaplessPlayback: true,
                      disableGestures: true,
                      imageProvider: imageProvider!,
                      loadingBuilder: (context, event) => const Padding(
                        padding: EdgeInsets.all(60),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                            color: Colors.black, // Filter will turn it light
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ].reversed.toList(),
            ),
          ],
        ],
      ),
    );
  }
}
