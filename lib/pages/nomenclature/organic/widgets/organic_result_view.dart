import 'package:auto_size_text/auto_size_text.dart';
import 'package:quimify_client/pages/nomenclature/organic/organic_image_page.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_section_title.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_coming_soon_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_report_dialog.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class OrganicResultView extends StatelessWidget {
  const OrganicResultView({
    Key? key,
    required this.fields,
    required this.imageProvider,
    required this.quimifyReportDialog,
  }) : super(key: key);

  final Map<String, String> fields;
  final ImageProvider? imageProvider;
  final QuimifyReportDialog quimifyReportDialog;

  void _pressedReportButton(BuildContext context) =>
      quimifyReportDialog.show(context);

  void _pressedShareButton(BuildContext context) =>
      quimifyComingSoonDialog.show(context);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        top: 30,
        bottom: 25,
        left: 25,
        right: 25,
      ),
      child: Column(
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
          const SizedBox(height: 25),
          Container(
            height: 1.5,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 25),
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
          const SizedBox(height: 25),
          if (imageProvider != null) ...[
            const QuimifySectionTitle.custom(
              title: 'Estructura',
              horizontalPadding: 0,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              dialog: quimifyComingSoonDialog,
            ),
            const SizedBox(height: 25),
            Stack(
              children: [
                Container(
                  width: double.infinity,
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
                      tightMode: true,
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
                Container(
                  padding: const EdgeInsets.all(5),
                  child: IconButton(
                    icon: Icon(
                      size: 30,
                      color: Theme.of(context).colorScheme.primary,
                      Icons.fullscreen_rounded,
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return OrganicImagePage(
                            imageProvider: imageProvider!,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class OrganicResultField extends StatelessWidget {
  const OrganicResultField({Key? key, required this.title, required this.field})
      : super(key: key);

  final String title, field;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
          strutStyle: const StrutStyle(fontSize: 16, height: 1.3),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AutoSizeText(
            field,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            strutStyle: const StrutStyle(fontSize: 16, height: 1.3),
          ),
        ),
      ],
    );
  }
}
