import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:csv/csv.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:quimify_client/pages/periodic_table/element_detail_page.dart';
import 'package:quimify_client/pages/periodic_table/periodic_element.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class PeriodicTablePage extends StatefulWidget {
  const PeriodicTablePage({Key? key}) : super(key: key);

  @override
  State<PeriodicTablePage> createState() => _PeriodicTablePageState();
}

class _PeriodicTablePageState extends State<PeriodicTablePage>
    with SingleTickerProviderStateMixin {
  Future<void> _loadElements() async {
    try {
      // Get the ByteData and decode with UTF8
      final ByteData fileData =
          await rootBundle.load('assets/csv/periodic_table.csv');
      final String rawData = utf8.decode(
          fileData.buffer
              .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes),
          allowMalformed: true // Add this to handle potentially malformed UTF8
          );

      String cleanData = rawData.replaceAll('Â', ''); //Fix typos

      // Parse CSV with specific settings
      final List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(cleanData);

      // Get headers
      final headers = csvTable[0].map((e) => e.toString().trim()).toList();

      // Convert to list of maps
      final List<Map<String, dynamic>> elementsList = [];
      for (var i = 1; i < csvTable.length; i++) {
        if (csvTable[i].length == headers.length) {
          // Validate row length
          final map = <String, dynamic>{};
          for (var j = 0; j < headers.length; j++) {
            var value = csvTable[i][j].toString().trim();

            // Handle numeric conversions
            if (headers[j] == 'atomic_weight' ||
                headers[j] == 'melting_point' ||
                headers[j] == 'boiling_point') {
              map[headers[j]] = double.tryParse(value) ?? 0.0;
            } else {
              map[headers[j]] = value;
            }
          }
          elementsList.add(map);
        }
      }

      setState(() {
        elements =
            elementsList.map((map) => PeriodicElement.fromCsv(map)).toList();
      });
    } catch (e, stackTrace) {
      log('Error loading elements: $e');
      log('Stack trace: $stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorLoadingElements),
          ),
        );
      }
    }
  }

  List<PeriodicElement> elements = [];
  late LinkedScrollControllerGroup _horizontalControllers;
  late LinkedScrollControllerGroup _verticalControllers;
  late ScrollController _horizontalMainController;
  late ScrollController _horizontalHeaderController;
  late ScrollController _verticalMainController;
  late ScrollController _verticalHeaderController;

  double _zoomLevel = 1.0;
  final double _targetZoomLevel = 1.0;
  static const double _minZoom = 0.75;
  static const double _maxZoom = 2.0;
  static const double _baseCellSize = 85.0;
  static const headerHeight = 40.0;

  late AnimationController _animationController;
  late Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();
    _loadElements();
    _horizontalControllers = LinkedScrollControllerGroup();
    _verticalControllers = LinkedScrollControllerGroup();
    _horizontalMainController = _horizontalControllers.addAndGet();
    _horizontalHeaderController = _horizontalControllers.addAndGet();
    _verticalMainController = _verticalControllers.addAndGet();
    _verticalHeaderController = _verticalControllers.addAndGet();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _zoomAnimation = Tween<double>(
      begin: _zoomLevel,
      end: _targetZoomLevel,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ))
      ..addListener(() {
        setState(() {
          _zoomLevel = _zoomAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _horizontalMainController.dispose();
    _horizontalHeaderController.dispose();
    _verticalMainController.dispose();
    _verticalHeaderController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cellSize = _baseCellSize * _zoomLevel;
    final headerWidth = 40.0 * _zoomLevel;

    return QuimifyScaffold.noAd(
      header: QuimifyPageBar(title: context.l10n.periodicTable),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          color: QuimifyColors.foreground(context),
          child: Column(
            children: [
              // Headers row
              SizedBox(
                height: headerHeight,
                child: Row(
                  children: [
                    Container(
                      width: headerWidth,
                      color: QuimifyColors.periodicTableHeader(context),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _horizontalHeaderController,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: List.generate(
                            18,
                            (index) => Container(
                              width: cellSize,
                              height: headerHeight,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              color: QuimifyColors.periodicTableHeader(context),
                              child: Center(
                                child: Text(
                                  [
                                    'A',
                                    'B',
                                    'C',
                                    'D',
                                    'E',
                                    'F',
                                    'G',
                                    'H',
                                    'I',
                                    'J',
                                    'K',
                                    'L',
                                    'N',
                                    'M',
                                    'O',
                                    'P',
                                    'Q',
                                    'R'
                                  ][index],
                                  style: TextStyle(
                                    color: QuimifyColors.primary(context),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row headers column
                    SingleChildScrollView(
                      controller: _verticalHeaderController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: List.generate(
                          9,
                          (index) => Container(
                            width: headerWidth,
                            height: cellSize + 2.0,
                            margin: const EdgeInsets.symmetric(vertical: 1.0),
                            color: QuimifyColors.periodicTableHeader(context),
                            child: Center(
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(
                                  color: QuimifyColors.primary(context),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Main periodic table grid
                    Expanded(
                      child: ScalableWrapper(
                        onScaleUpdate: (scale) {
                          setState(() {
                            _zoomLevel = scale.clamp(_minZoom, _maxZoom);
                          });
                        },
                        child: SingleChildScrollView(
                          controller: _horizontalMainController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: SingleChildScrollView(
                            controller: _verticalMainController,
                            physics: const BouncingScrollPhysics(),
                            child: SizedBox(
                              width: cellSize * 18 + (17 * 2.0),
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 2.0),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 18,
                                        childAspectRatio: 1.0,
                                        crossAxisSpacing: 2.0,
                                        mainAxisSpacing: 2.0,
                                      ),
                                      itemCount: 18 * 9,
                                      itemBuilder: (context, index) {
                                        final row = index ~/ 18;
                                        final col = index % 18;
                                        final element =
                                            elements.firstWhereOrNull((e) =>
                                                e.tableRow == row + 1 &&
                                                e.columnIndex == col);
                                        if (element == null) return Container();
                                        return _buildElementCell(element);
                                      },
                                    ),
                                  ),
                                  // Legend
                                  Positioned(
                                    left: cellSize * 3.5,
                                    top: cellSize * .3,
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      child: _Legend(zoomLevel: _zoomLevel),
                                    ),
                                  ),
                                  // Logo
                                  Positioned(
                                    left: cellSize * 1,
                                    top: cellSize * 7.6,
                                    child: SizedBox(
                                      width: cellSize * 1.2,
                                      height: cellSize * 1.2,
                                      child: Image.asset(
                                        'assets/images/logo-branding.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildElementCell(PeriodicElement element) {
    final textScaleFactor = (_zoomLevel * 0.8).clamp(0.5, 1.2);
    final currentLanguage = Localizations.localeOf(context).languageCode;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ElementDetailPage(element: element),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: element.getBackgroundColor(),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: element.getBackgroundColor(),
          ),
        ),
        padding: const EdgeInsets.all(2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              element.atomicNumber.toString(),
              style: TextStyle(
                fontSize: 18 * textScaleFactor,
                color: element.getForegroundColor(),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      element.symbol,
                      style: TextStyle(
                        fontSize: 28 * textScaleFactor,
                        fontWeight: FontWeight.bold,
                        color: element.getForegroundColor(),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentLanguage == 'es' ? element.name : element.nameEn,
                      style: TextStyle(
                        fontSize: 14 * textScaleFactor,
                        color: element.getForegroundColor(),
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      element.atomicWeight.toStringAsFixed(3),
                      style: TextStyle(
                        fontSize: 12 * textScaleFactor,
                        color: element.getForegroundColor(),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final double zoomLevel;

  const _Legend({
    Key? key,
    required this.zoomLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0 * zoomLevel),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendItem(
                    color: QuimifyColors.reactiveNonMetal(),
                    borderColor: QuimifyColors.reactiveNonMetalLight(),
                    label: context.l10n.legendNonMetal,
                    zoomLevel: zoomLevel,
                  ),
                  SizedBox(height: 12 * zoomLevel),
                  _LegendItem(
                    color: QuimifyColors.transitionMetal(),
                    borderColor: QuimifyColors.transitionMetalLight(),
                    label: context.l10n.legendTransitionMetal,
                    zoomLevel: zoomLevel,
                  ),
                  SizedBox(height: 12 * zoomLevel),
                  _LegendItem(
                    color: QuimifyColors.halogene(),
                    borderColor: QuimifyColors.halogeneLight(),
                    label: context.l10n.legendHalogene,
                    zoomLevel: zoomLevel,
                  ),
                  SizedBox(height: 12 * zoomLevel),
                  _LegendItem(
                    color: QuimifyColors.postTransitionMetal(),
                    borderColor: QuimifyColors.postTransitionMetalLight(),
                    label: context.l10n.legendOtherMetal,
                    zoomLevel: zoomLevel,
                  ),
                  SizedBox(height: 12 * zoomLevel),
                  _LegendItem(
                    color: QuimifyColors.lanthanide(),
                    borderColor: QuimifyColors.lanthanideLight(),
                    label: context.l10n.legendLanthanide,
                    zoomLevel: zoomLevel,
                  ),
                ],
              ),
              SizedBox(width: 24 * zoomLevel),
              // Right column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendItem(
                    color: QuimifyColors.nobleGas(),
                    borderColor: QuimifyColors.nobleGasLight(),
                    label: context.l10n.legendNobleGas,
                    zoomLevel: zoomLevel,
                  ),
                  SizedBox(height: 12 * zoomLevel),
                  _LegendItem(
                    color: QuimifyColors.metalloid(),
                    borderColor: QuimifyColors.metalloidLight(),
                    label: context.l10n.legendMetalloid,
                    zoomLevel: zoomLevel,
                  ),
                  SizedBox(height: 12 * zoomLevel),
                  _LegendItem(
                    color: QuimifyColors.actinide(),
                    borderColor: QuimifyColors.actinideLight(),
                    label: context.l10n.legendActinide,
                    zoomLevel: zoomLevel,
                  ),
                  SizedBox(height: 12 * zoomLevel),
                  _LegendItem(
                    color: QuimifyColors.alkalineEarthMetal(),
                    borderColor: QuimifyColors.alkalineEarthMetalLight(),
                    label: context.l10n.legendAlkalineEarthMetal,
                    zoomLevel: zoomLevel,
                  ),
                  SizedBox(height: 12 * zoomLevel),
                  _LegendItem(
                    color: QuimifyColors.alkaliMetal(),
                    borderColor: QuimifyColors.alkaliMetalLight(),
                    label: context.l10n.legendAlkaliMetal,
                    zoomLevel: zoomLevel,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final String label;
  final double zoomLevel;

  const _LegendItem({
    Key? key,
    required this.color,
    required this.borderColor,
    required this.label,
    required this.zoomLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24 * zoomLevel,
          height: 24 * zoomLevel,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: borderColor, width: 4),
            borderRadius: BorderRadius.circular(4 * zoomLevel),
          ),
        ),
        SizedBox(width: 8 * zoomLevel),
        Text(
          label,
          style: TextStyle(
            color: QuimifyColors.primary(context),
            fontSize: 18 * zoomLevel,
          ),
        ),
      ],
    );
  }
}

class CustomScaleGestureRecognizer extends ScaleGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}

class ScalableWrapper extends StatefulWidget {
  final Widget child;
  final void Function(double) onScaleUpdate;

  const ScalableWrapper({
    Key? key,
    required this.child,
    required this.onScaleUpdate,
  }) : super(key: key);

  @override
  State<ScalableWrapper> createState() => _ScalableWrapperState();
}

class _ScalableWrapperState extends State<ScalableWrapper> {
  final CustomScaleGestureRecognizer _scaleGestureRecognizer =
      CustomScaleGestureRecognizer();
  double _startScale = 1.0;
  double _lastScale = 1.0;

  @override
  void initState() {
    super.initState();
    _scaleGestureRecognizer
      ..onStart = _handleScaleStart
      ..onUpdate = _handleScaleUpdate
      ..onEnd = _handleScaleEnd;
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _startScale = _lastScale;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    _currentScale = (_startScale * details.scale);
    widget.onScaleUpdate(_currentScale);
  }

  double _currentScale = 1.0; // Add this as a class field

  void _handleScaleEnd(ScaleEndDetails details) {
    _lastScale = _currentScale;
    _startScale = 1.0;
  }

  @override
  void dispose() {
    _scaleGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        CustomScaleGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<CustomScaleGestureRecognizer>(
          () => _scaleGestureRecognizer,
          (CustomScaleGestureRecognizer instance) {},
        ),
      },
      child: widget.child,
    );
  }
}
