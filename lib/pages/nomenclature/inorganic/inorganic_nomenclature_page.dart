import 'package:quimify_client/api/api.dart';
import 'package:quimify_client/api/results/inorganic_result.dart';
import 'package:quimify_client/pages/nomenclature/inorganic/widgets/inorganic_result_view.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_search_bar.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_loading.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_message_dialog.dart';
import 'package:quimify_client/pages/widgets/popups/quimify_no_internet_dialog.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:quimify_client/utils/internet.dart';
import 'package:quimify_client/utils/text.dart';
import 'package:flutter/material.dart';

class InorganicNomenclaturePage extends StatefulWidget {
  const InorganicNomenclaturePage({Key? key}) : super(key: key);

  @override
  State<InorganicNomenclaturePage> createState() =>
      _InorganicNomenclaturePageState();
}

class _InorganicNomenclaturePageState extends State<InorganicNomenclaturePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  String _labelText = 'NaCl, óxido de hierro...';

  final List<InorganicResultView> _results = [
    InorganicResultView(
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
      startLoading(context);

      InorganicResult? result =
          await Api().getInorganic(toDigits(input), photo);

      stopLoading();

      if (result != null) {
        if (result.present) {
          setState(
            () => _results.add(
              InorganicResultView(
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
          QuimifyMessageDialog.reportable(
            title: 'Sin resultado',
            details: 'No se ha encontrado:\n"$input"',
            reportLabel: 'Formulación inorgánica, búsqueda de "$input"',
          ).show(context);
        }
      } else {
        // Client already reported an error in this case
        if (!mounted) return; // For security reasons
        checkInternetConnection().then(
              (bool hasInternetConnection) {
            if (hasInternetConnection) {
              const QuimifyMessageDialog(
                title: 'Sin resultado',
              ).show(context);
            } else {
              quimifyNoInternetDialog.show(context);
            }
          },
        );
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
    return WillPopScope(
      onWillPop: () async {
        stopLoading();
        return true;
      },
      child: GestureDetector(
        onTap: () => _textFocusNode.unfocus(),
        child: QuimifyScaffold(
          header: Column(
            children: [
              const QuimifyPageBar(title: 'Formulación inorgánica'),
              QuimifySearchBar(
                label: _labelText,
                controller: _textController,
                focusNode: _textFocusNode,
                corrector: formatInorganicFormulaOrName,
                onSubmitted: (input) => _search(input, false),
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.only(
              top: 30,
              bottom: 25,
              left: 25,
              right: 25,
            ),
            child: Wrap(
              verticalDirection: VerticalDirection.up,
              runSpacing: 25,
              children: _results,
            ),
          ),
        ),
      ),
    );
  }
}
