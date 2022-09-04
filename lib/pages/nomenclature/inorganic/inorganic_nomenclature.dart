import 'package:auto_size_text/auto_size_text.dart';
import 'package:cliente/widgets/page_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:cliente/pages/nomenclature/widgets/search_bar.dart';
import 'package:cliente/constants.dart';

import '../../../api/api.dart';
import '../../../api/results/inorganic_result.dart';
import '../../../utils/text.dart';
import '../../../widgets/button.dart';
import '../../../widgets/dialog_popup.dart';

class InorganicNomenclaturePage extends StatefulWidget {
  const InorganicNomenclaturePage({Key? key}) : super(key: key);

  @override
  State<InorganicNomenclaturePage> createState() =>
      _InorganicNomenclaturePageState();
}

class _InorganicNomenclaturePageState extends State<InorganicNomenclaturePage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  String _labelText = 'NaCl, óxido de hierro...';
  final List<SearchResult> _results = [
    SearchResult(
      query: 'NaCl',
      inorganicResult: InorganicResult(
        true,
        false,
        'NaCl',
        'cloruro de sodio',
        'monocloruro de sodio',
        '58.44',
        '2.16',
        '1074.15',
        '1686.15',
        null,
        null,
      ),
    ),
  ];

  Future<void> _search(String input, bool photo) async {
    if (!isEmptyWithBlanks(input)) {
      InorganicResult? result =
          await Api().getInorganic(toDigits(input), photo);

      if (result != null) {
        if (result.present) {
          setState(
            () => _results.insert(
              0,
              SearchResult(
                query: input,
                inorganicResult: result,
              ),
            ),
          );

          // UI/UX actions:

          _labelText = input; // Sets previous input as label
          _textController.clear(); // Clears input
          _textFocusNode.unfocus(); // Hides keyboard

          _scrollToStart(); // Goes to the top of the page
        } else {
          if (!mounted) return; // For security reasons
          DialogPopup.reportableMessage(
            title: 'Sin resultado',
            details: 'No se ha encontrado "$input".',
          ).show(context);
        }
      } else {
        if (!mounted) return; // For security reasons
        DialogPopup.message(
          title: 'Sin resultado',
          details: 'No se ha encontrado "$input".',
        ).show(context);
      }
    }
  }

  void _scrollToStart() {
    // Goes to the top of the page after a delay:
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 400),
      ),
    );
  }

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
            const PageAppBar(title: 'Formulación inorgánica'),
            SearchBar(
              label: _labelText,
              controller: _textController,
              focusNode: _textFocusNode,
              corrector: formatInorganicFormulaOrName,
              onSubmitted: (input) => _search(input, false),
            ),
            // Body:
            Expanded(
              child: Container(
                decoration: bodyBoxDecoration,
                // To avoid rounded corners overflow:
                clipBehavior: Clip.hardEdge,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(
                      top: 30, bottom: 5, left: 25, right: 25),
                  child: Column(
                    children: [
                      ..._results.toList(),
                      const SizedBox(height: 10),
                    ],
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

class SearchResult extends StatefulWidget {
  SearchResult({Key? key, required this.query, required this.inorganicResult})
      : super(key: key);

  final String query;
  final InorganicResult inorganicResult;

  late List<SearchResultQuantity> _quantities;
  bool _isCollapsed = true;

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final AutoSizeGroup _quantityTitleAutoSizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    widget._quantities = [
      if (widget.inorganicResult.mass != null)
        SearchResultQuantity(
          title: 'Masa',
          quantity: widget.inorganicResult.mass!,
          unit: 'g/mol',
          titleAutoSizeGroup: _quantityTitleAutoSizeGroup,
        ),
      if (widget.inorganicResult.density != null)
        SearchResultQuantity(
          title: 'Densidad',
          quantity: widget.inorganicResult.density!,
          unit: 'g/cm³',
          titleAutoSizeGroup: _quantityTitleAutoSizeGroup,
        ),
      if (widget.inorganicResult.meltingPoint != null)
        SearchResultQuantity(
          title: 'P. de fusión',
          quantity: widget.inorganicResult.meltingPoint!,
          unit: 'K',
          titleAutoSizeGroup: _quantityTitleAutoSizeGroup,
        ),
      if (widget.inorganicResult.boilingPoint != null)
        SearchResultQuantity(
          title: 'P. de ebullición',
          quantity: widget.inorganicResult.boilingPoint!,
          unit: 'K',
          titleAutoSizeGroup: _quantityTitleAutoSizeGroup,
        ),
    ];

    return GestureDetector(
      onTap: () => setState(() => widget._isCollapsed = !widget._isCollapsed),
      child: Column(
        children: [
          // Head: (Result of: ...)
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                const Text(
                  'Búsqueda: ',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 14,
                  ),
                ),
                Text(
                  widget.query,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Separator:
          const SizedBox(height: 2),
          // Body:
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            padding:
                const EdgeInsets.only(top: 20, bottom: 15, left: 20, right: 20),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    toSubscripts(widget.inorganicResult.formula),
                    style: const TextStyle(
                      color: quimifyTeal,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    widget.inorganicResult.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                if (widget.inorganicResult.synonym != null) ...[
                  const SizedBox(height: 2.5),
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      'y ${widget.inorganicResult.synonym!}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
                AnimatedSize(
                  duration:
                      Duration(milliseconds: widget._isCollapsed ? 150 : 300),
                  curve: Curves.easeOut,
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: widget._isCollapsed ? 0 : null,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        if (widget._quantities.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              color: quimifyTeal.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 50,
                                      child: widget._quantities[0],
                                    ),
                                    if (widget._quantities.length > 1) ...[
                                      const SizedBox(width: 20),
                                      Expanded(
                                        flex: 50,
                                        child: widget._quantities[1],
                                      ),
                                    ],
                                  ],
                                ),
                                if (widget._quantities.length > 2) ...[
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 50,
                                        child: widget._quantities[2],
                                      ),
                                      if (widget._quantities.length > 3) ...[
                                        const SizedBox(width: 20),
                                        Expanded(
                                          flex: 50,
                                          child: widget._quantities[3],
                                        ),
                                      ],
                                    ],
                                  )
                                ],
                              ],
                            ),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: SearchResultButton(
                                color: const Color.fromARGB(255, 255, 96, 96),
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 241, 241),
                                icon: Image.asset(
                                  'assets/images/icons/report.png',
                                  color: const Color.fromARGB(255, 255, 96, 96),
                                  width: 18,
                                ),
                                text: 'Reportar',
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Expanded(
                              child: SearchResultButton(
                                color: Color.fromARGB(255, 56, 133, 224),
                                backgroundColor:
                                    Color.fromARGB(255, 239, 246, 253),
                                icon: Icon(
                                  Icons.share_outlined,
                                  color: Color.fromARGB(255, 56, 133, 224),
                                  size: 18,
                                ),
                                text: 'Compartir',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: RotatedBox(
                    quarterTurns: widget._isCollapsed ? 2 : 0,
                    child: Image.asset(
                      'assets/images/icons/narrow_arrow.png',
                      color: Colors.black26,
                      width: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class SearchResultQuantity extends StatelessWidget {
  const SearchResultQuantity(
      {Key? key,
      required this.title,
      required this.quantity,
      required this.unit,
      required this.titleAutoSizeGroup})
      : super(key: key);

  final String title, quantity, unit;
  final AutoSizeGroup titleAutoSizeGroup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          title,
          maxLines: 1,
          stepGranularity: 0.1,
          group: titleAutoSizeGroup,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 5),
        AutoSizeText(
          '$quantity $unit',
          maxLines: 1,
          stepGranularity: 0.1,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class SearchResultButton extends StatelessWidget {
  const SearchResultButton(
      {Key? key,
      required this.icon,
      required this.text,
      required this.color,
      required this.backgroundColor})
      : super(key: key);

  final Widget icon;
  final String text;
  final Color color, backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Button(
      width: 50,
      color: backgroundColor,
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Spacer(),
          icon,
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 16,
              //fontWeight: FontWeight.bold
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
