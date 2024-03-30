import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:quimify_client/pages/organic/diagrams/diagram_2d_page.dart';
import 'package:quimify_client/pages/organic/diagrams/diagram_3d_page.dart';
import 'package:quimify_client/pages/organic/widgets/structure_help_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/coming_soon_dialog.dart';
import 'package:quimify_client/pages/widgets/dialogs/report/report_dialog.dart';
import 'package:quimify_client/pages/widgets/objects/help_button.dart';
import 'package:quimify_client/pages/widgets/objects/history_button.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_field.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';
import 'package:quimify_client/pages/widgets/objects/report_button.dart';
import 'package:quimify_client/pages/widgets/objects/share_button.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:signed_spacing_flex/signed_spacing_flex.dart';

class OrganicResultView extends StatelessWidget {
  const OrganicResultView({
    Key? key,
    this.scrollController,
    required this.fields,
    required this.imageProvider,
    required this.url3D,
    required this.onHistoryPressed,
    required this.reportDialog,
  }) : super(key: key);

  final ScrollController? scrollController;
  final Map<String, String> fields;
  final ImageProvider? imageProvider;
  final String? url3D;
  final Function(BuildContext) onHistoryPressed;
  final ReportDialog reportDialog;

  _pressedHistoryButton(BuildContext context) => onHistoryPressed(context);

  _pressedReportButton(BuildContext context) => reportDialog.show(context);

  _pressedShareButton(BuildContext context) => comingSoonDialog.show(context);

  static const double _buttonHeight = 44;
  static const double _diagramHeight = 225; // TODO adaptive

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Resultado',
                style: TextStyle(
                  color: QuimifyColors.primary(context),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              HistoryButton(
                height: _buttonHeight,
                iconSize: 20,
                onPressed: () => _pressedHistoryButton(context),
              ),
              const SizedBox(width: 12),
              ShareButton(
                height: _buttonHeight,
                onPressed: () => _pressedShareButton(context),
              ),
              const SizedBox(width: 12),
              ReportButton(
                height: _buttonHeight,
                size: 18,
                onPressed: () => _pressedReportButton(context),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: QuimifyColors.textHighlight(context),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SignedSpacingColumn(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: fields.entries
                  .map(
                    (field) => QuimifyField(
                      title: field.key,
                      titleColor: QuimifyColors.primary(context),
                      value: field.value,
                      valueBold: true,
                    ),
                  )
                  .toList(),
            ),
          ),
          if (imageProvider != null) ...[
            const SizedBox(height: 15),
            Row(
              children: [
                Text(
                  'Estructura',
                  style: TextStyle(
                    color: QuimifyColors.primary(context),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                url3D != null
                    ? SizedBox(
                        width: 118,
                        child: QuimifyIconButton(
                          height: _buttonHeight,
                          backgroundColor: QuimifyColors.allBlue(context),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => Diagram3DPage(
                                url: url3D!,
                              ),
                            ),
                          ),
                          icon: Icon(
                            Icons.threesixty_outlined,
                            size: 18,
                            color: QuimifyColors.inverseText(context),
                          ),
                          text: Text(
                            'Ver en 3D',
                            style: TextStyle(
                              color: QuimifyColors.inverseText(context),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(height: _buttonHeight),
              ],
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
                            builder: (BuildContext context) => Diagram2DPage(
                              imageProvider: imageProvider!,
                            ),
                          ),
                        ),
                        icon: Icon(
                          size: 30,
                          color: QuimifyColors.primary(context),
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
                  height: _diagramHeight,
                  decoration: BoxDecoration(
                    color: QuimifyColors.diagramBackground(context),
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
                      backgroundDecoration: const BoxDecoration(),
                      // Needed
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
