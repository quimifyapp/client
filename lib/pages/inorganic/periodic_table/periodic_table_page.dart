import 'package:collection/collection.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:quimify_client/pages/inorganic/periodic_table/element_detail_page.dart';
import 'package:quimify_client/pages/inorganic/periodic_table/periodic_element.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class PeriodicTablePage extends StatefulWidget {
  const PeriodicTablePage({Key? key}) : super(key: key);

  @override
  State<PeriodicTablePage> createState() => _PeriodicTablePageState();
}

class _PeriodicTablePageState extends State<PeriodicTablePage> {
  List<PeriodicElement> elements = [];

  late LinkedScrollControllerGroup _horizontalControllers;
  late LinkedScrollControllerGroup _verticalControllers;
  late ScrollController _horizontalMainController;
  late ScrollController _horizontalHeaderController;
  late ScrollController _verticalMainController;
  late ScrollController _verticalHeaderController;

  double _zoomLevel = 1.0;
  double _previousScale = 1.0;
  static const double _minZoom = 0.75;
  static const double _maxZoom = 2.0;
  static const double _baseCellSize = 85.0;

  Future<void> _loadElements() async {
    try {
      final rawData =
          await rootBundle.loadString('assets/csv/periodic_table.csv');
      final List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(rawData);

      // Get headers
      final headers = csvTable[0].map((e) => e.toString()).toList();

      // Convert to list of maps
      final List<Map<String, dynamic>> data = [];
      for (var i = 1; i < csvTable.length; i++) {
        final map = <String, dynamic>{};
        for (var j = 0; j < headers.length; j++) {
          map[headers[j]] = csvTable[i][j];
        }
        data.add(map);
      }

      setState(() {
        elements = data.map((map) => PeriodicElement.fromCsv(map)).toList();
      });
    } catch (e) {
      print('Error loading elements: $e');
    }
  }

  void _onScaleStart(ScaleStartDetails details) {
    _previousScale = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.scale == 1.0) return; // Ignore non-zoom gestures

    setState(() {
      // Calculate the incremental change in scale
      final double delta = details.scale / _previousScale;
      _previousScale = details.scale;

      // Apply smooth damping to the zoom
      final double dampedDelta = 1.0 + (delta - 1.0) * 0.5;

      // Update zoom level with smooth interpolation
      _zoomLevel = (_zoomLevel * dampedDelta).clamp(_minZoom, _maxZoom);
    });
  }

  void _onZoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + 0.25).clamp(_minZoom, _maxZoom);
    });
  }

  void _onZoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - 0.25).clamp(_minZoom, _maxZoom);
    });
  }

  final TransformationController _transformationController =
      TransformationController();

  void _onInteractionUpdate(ScaleUpdateDetails details) {
    setState(() {
      _zoomLevel = (_zoomLevel * details.scale).clamp(_minZoom, _maxZoom);
    });
  }

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
  }

  @override
  void dispose() {
    _horizontalMainController.dispose();
    _horizontalHeaderController.dispose();
    _verticalMainController.dispose();
    _verticalHeaderController.dispose();
    _transformationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cellSize = _baseCellSize * _zoomLevel;
    final headerHeight = 40.0;
    final headerWidth = 40.0 * _zoomLevel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla periódica'),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFF272727),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: headerWidth,
                  height: headerHeight,
                  color: const Color(0xFF323232),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalHeaderController,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _buildColumnHeaders(cellSize),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    controller: _verticalHeaderController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: _buildRowHeaders(cellSize, headerWidth),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onScaleStart: _onScaleStart,
                      onScaleUpdate: _onScaleUpdate,
                      child: SingleChildScrollView(
                        controller: _horizontalMainController,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: SingleChildScrollView(
                          controller: _verticalMainController,
                          physics: const BouncingScrollPhysics(),
                          child: Stack(
                            children: [
// Inside the Stack in the build method:
                              SizedBox(
                                width: cellSize * 18 +
                                    (17 *
                                        2.0), // Keep the spacing for proper alignment
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 18,
                                    childAspectRatio: 1.0,
                                    crossAxisSpacing:
                                        2.0, // Match the spacing in width calculation
                                    mainAxisSpacing:
                                        2.0, // Keep vertical spacing consistent
                                  ),
                                  itemCount:
                                      18 * 9, // Change to 9 rows instead of 10
                                  itemBuilder: (context, index) {
                                    final row = index ~/ 18;
                                    final col = index % 18;
                                    final element = elements.firstWhereOrNull(
                                        (e) =>
                                            e.tableRow == row + 1 &&
                                            e.columnIndex == col);
                                    if (element == null) return Container();
                                    return _buildElementCell(element);
                                  },
                                ),
                              ),
                              Positioned(
                                left: cellSize * 3.5,
                                top: cellSize * .3,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: _Legend(zoomLevel: _zoomLevel),
                                ),
                              ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildColumnHeaders(double cellSize) {
    final headers = [
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
    ];

    return headers
        .map((header) => Container(
              width: cellSize,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              color: const Color(0xFF323232),
              child: Center(
                child: Text(
                  header,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ))
        .toList();
  }

  List<Widget> _buildRowHeaders(double height, double width) {
    return List.generate(
        9,
        (index) => Container(
              width: width,
              height: height, // Using cellSize instead of headerHeight
              margin: const EdgeInsets.symmetric(vertical: 1.0),
              color: const Color(0xFF323232),
              child: Center(
                child: Text(
                  (index + 1).toString(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ));
  }

  Widget _buildElementCell(PeriodicElement element) {
    final textScaleFactor = (_zoomLevel * 0.8).clamp(0.5, 1.2);

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
                      element.name,
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

  Color _getElementColor(String element) {
    final categoryColors = {
      'no_metal': Colors.purple.shade200,
      'metal_transition': Colors.blue.shade200,
      'halogen': QuimifyColors.teal(),
      'other_metal': Colors.green.shade200,
      'gas_noble': const Color(0xFFFFE4B5),
      'alkaline': Colors.pink.shade200,
      'metal_alkaline': Colors.pink.shade300,
      'lanthanide': Colors.grey.shade400,
      'actinide': Colors.red.shade200,
      'metalloid': const Color(0xFFFFDEAD),
    };

    final elementCategories = {
      'H': 'no_metal',
      'He': 'gas_noble',
      'Li': 'alkaline',
      'Be': 'metal_alkaline',
      // Add all element categories here
    };

    final category = elementCategories[element];
    return category != null ? categoryColors[category]! : QuimifyColors.teal();
  }

  int _getAtomicNumber(int row, int col) {
    final atomicNumbers = {
      '0,0': 1, // H
      '0,17': 2, // He
      '1,0': 3, // Li
      '1,1': 4, // Be
      // Add all atomic numbers here
    };

    return atomicNumbers['$row,$col'] ?? 0;
  }

  String _getAtomicMass(int row, int col) {
    final atomicMasses = {
      '0,0': '1.0078', // H
      '0,17': '4.0026', // He
      '1,0': '6.9410', // Li
      '1,1': '9.0122', // Be
      // Add all atomic masses here
    };

    return atomicMasses['$row,$col'] ?? '';
  }

  MapEntry<String, String>? _getElementAtPosition(int row, int col) {
    final elements = {
      'H': 'Hidrógeno',
      'He': 'Helio',
      'Li': 'Litio',
      'Be': 'Berilio',
      'B': 'Boro',
      'C': 'Carbono',
      'N': 'Nitrógeno',
      'O': 'Oxígeno',
      'F': 'Flúor',
      'Ne': 'Neón',
      'Na': 'Sodio',
      'Mg': 'Magnesio',
      // Add all elements here
    };

    // Define element positions
    if (row == 0 && col == 0) return MapEntry('H', elements['H']!);
    if (row == 0 && col == 17) return MapEntry('He', elements['He']!);
    if (row == 1 && col == 0) return MapEntry('Li', elements['Li']!);
    if (row == 1 && col == 1) return MapEntry('Be', elements['Be']!);
    // Add all element positions here

    return null;
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
                    label: 'No metal',
                    zoomLevel: zoomLevel,
                  ),
                  SizedBox(height: 12 * zoomLevel),
                  _LegendItem(
                    color: QuimifyColors.transitionMetal(),
                    borderColor: QuimifyColors.transitionMetalLight(),
                    label: 'Metal de transición',
                    zoomLevel: zoomLevel,
                  ),
                  SizedBox(height: 12 * zoomLevel),
                  _LegendItem(
                    color: QuimifyColors.halogene(),
                    borderColor: QuimifyColors.halogeneLight(),
                    label: 'Halógeno',
                    zoomLevel: zoomLevel,
                  ),
                  SizedBox(height: 12 * zoomLevel),
                  _LegendItem(
                    color: QuimifyColors.postTransitionMetal(),
                    borderColor: QuimifyColors.postTransitionMetalLight(),
                    label: 'Otros metales',
                    zoomLevel: zoomLevel,
                  ),
                  SizedBox(height: 12 * zoomLevel),
                  _LegendItem(
                    color: QuimifyColors.lanthanide(),
                    borderColor: QuimifyColors.lanthanideLight(),
                    label: 'Lantánido',
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
                    label: 'Gas noble',
                    zoomLevel: zoomLevel,
                  ),
                  SizedBox(height: 12 * zoomLevel),
                  _LegendItem(
                    color: QuimifyColors.metalloid(),
                    borderColor: QuimifyColors.metalloidLight(),
                    label: 'Metaloide',
                    zoomLevel: zoomLevel,
                  ),
                  SizedBox(height: 12 * zoomLevel),
                  _LegendItem(
                    color: QuimifyColors.actinide(),
                    borderColor: QuimifyColors.actinideLight(),
                    label: 'Actínido',
                    zoomLevel: zoomLevel,
                  ),
                  SizedBox(height: 12 * zoomLevel),
                  _LegendItem(
                    color: QuimifyColors.alkalineEarthMetal(),
                    borderColor: QuimifyColors.alkalineEarthMetalLight(),
                    label: 'Alcalinotérreo',
                    zoomLevel: zoomLevel,
                  ),
                  SizedBox(height: 12 * zoomLevel),
                  _LegendItem(
                    color: QuimifyColors.alkaliMetal(),
                    borderColor: QuimifyColors.alkaliMetalLight(),
                    label: 'Metal alcalino',
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
            color: Colors.white70,
            fontSize: 18 * zoomLevel,
          ),
        ),
      ],
    );
  }
}
