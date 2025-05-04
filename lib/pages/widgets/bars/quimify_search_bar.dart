import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:quimify_client/pages/widgets/bars/camera_button_handler.dart';
import 'package:quimify_client/pages/widgets/dialogs/messages/message_dialog.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/text.dart';
import 'package:quimify_client/utils/localisation_extension.dart';

class QuimifySearchBar extends StatefulWidget {
  const QuimifySearchBar({
    Key? key,
    required this.label,
    required this.focusNode,
    required this.textEditingController,
    required this.inputCorrector,
    required this.onSubmitted,
    required this.completionCallBack,
    required this.completionCorrector,
    required this.onCompletionPressed,
    required this.isOrganic,
  }) : super(key: key);

  final bool isOrganic;
  final String label;
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final String Function(String) inputCorrector, completionCorrector;
  final Future<String?> Function(String) completionCallBack;
  final Function(String) onSubmitted, onCompletionPressed;

  @override
  State<QuimifySearchBar> createState() => _QuimifySearchBarState();
}

class _QuimifySearchBarState extends State<QuimifySearchBar> {
  final CameraButtonHandler _cameraHandler = CameraButtonHandler();

  bool _isProcessingCompounds = false;

  // Max compounds
  static const _maxInorganicCompounds = 5;

  Future<void> _processInorganicCompounds(String text) async {
    if (_isProcessingCompounds) return;
    _isProcessingCompounds = true;

    try {
      // Split the text by newlines and filter out empty lines
      final compounds = text
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      List<String> totalCompounds = [];
      for (int i = 0; i < compounds.length; i++) {
        final compound = compounds[i];
        if (totalCompounds.length < _maxInorganicCompounds) {
          totalCompounds.add(compound);
        } else {
          break;
        }
      }

      // Reverse totalCompounds
      final reversedCompoundsList = totalCompounds.reversed.toList();

      await Future.forEach(reversedCompoundsList, (compound) async {
        // Update the text field with current compound
        setState(() {
          widget.textEditingController.text = compound;
        });

        // Submit the compound and WAIT for the result to complete
        // This will wait for the API call and UI updates to finish
        await widget.onSubmitted(compound);
      });

      // If there are more compounds than the max, show a message
      if (compounds.length > _maxInorganicCompounds) {
        if (context.mounted) {
          MessageDialog(
            title: context.l10n.warning,
            details: context.l10n.onlyXAmountCanBeProcessedAtATime(
              _maxInorganicCompounds,
            ),
          ).show(context);
        }
      }
    } finally {
      _isProcessingCompounds = false;
    }
  }

  void _handleExtractedText(String text) async {
    if (widget.isOrganic) {
      // For organic compounds, only process the first one
      final compounds = text
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      if (compounds.isNotEmpty) {
        // Process only the first compound
        setState(() {
          widget.textEditingController.text = compounds[0];
        });

        await widget.onSubmitted(compounds[0]);

        // Show warning if there were more compounds
        if (compounds.length > 1 && context.mounted) {
          MessageDialog(
            title: context.l10n.warning,
            details:
                context.l10n.forOrganicCompoundsOnlyOneCanBeProcessedAtATime,
          ).show(context);
        }
      }
    } else {
      // Process inorganic compounds line by line
      await _processInorganicCompounds(text);
    }
  }

  // Completions stream:
  late String? _lastCompletion;
  late bool _isLoadingCompletion = false;

  Future<String?> _getCompletion(String input) async {
    if (isEmptyWithBlanks(input)) {
      return null;
    } else if (_isLoadingCompletion) {
      return _lastCompletion;
    }

    String? completion;

    _isLoadingCompletion = true;
    completion = await widget.completionCallBack(input);
    _isLoadingCompletion = false;

    _lastCompletion = completion;

    return completion;
  }

  Future<List<String>> _getCompletions(String input) async {
    String? completion = await _getCompletion(input);
    return (completion == null || completion == '') ? [] : [completion];
  }

  _eraseInitialAndFinalBlanks() {
    setState(() => widget.textEditingController.text = noInitialAndFinalBlanks(
        widget.textEditingController.text)); // Clears input
  }

  _tappedOutsideText() {
    widget.focusNode.unfocus(); // Hides keyboard

    if (isEmptyWithBlanks(widget.textEditingController.text)) {
      widget.textEditingController.clear(); // Clears input
    } else {
      _eraseInitialAndFinalBlanks();
    }
  }

  _search() {
    if (widget.focusNode.hasPrimaryFocus) {
      widget.focusNode.unfocus();
      _eraseInitialAndFinalBlanks();
      widget.onSubmitted(widget.textEditingController.text);
    } else {
      widget.focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 20,
        left: 20,
        right: 20,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: QuimifyColors.foreground(context),
              ),
              child: TypeAheadField(
                focusNode: widget.focusNode,
                controller: widget.textEditingController,
                builder: (context, controller, focusNode) => TextField(
                  controller: controller,
                  focusNode: focusNode,
                  // Settings:
                  autocorrect: false,
                  enableSuggestions: false,
                  // Aspect:
                  cursorColor: QuimifyColors.primary(context),
                  style: TextStyle(
                    color: QuimifyColors.primary(context),
                    fontSize: 18,
                    height: 1.2, // Cursor height
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(right: 14),
                    // So vertical center works:
                    isCollapsed: true,
                    alignLabelWithHint: true,
                    // For label
                    // Label:
                    labelText: widget.label,
                    labelStyle: TextStyle(
                      color: QuimifyColors.secondary(context),
                    ),
                    // So hint doesn't go up while typing:
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    // To remove bottom border:
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    // Search icon:
                    prefixIcon: Transform.scale(
                      scale: 0.7,
                      child: IconButton(
                        padding: const EdgeInsets.only(
                          top: 8 + 1,
                          bottom: 8 - 1,
                          left: 8,
                          right: 8,
                        ),
                        icon: Image.asset(
                          'assets/images/icons/search.png',
                          color: QuimifyColors.primary(context),
                        ),
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: _search,
                      ),
                    ),
                  ),
                  // Logic:
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(inputFormatter),
                  ],
                  textInputAction: TextInputAction.search,
                  onChanged: (input) => widget.textEditingController.value =
                      widget.textEditingController.value
                          .copyWith(text: widget.inputCorrector(input)),
                  onSubmitted: (input) {
                    _eraseInitialAndFinalBlanks();
                    widget.onSubmitted(input);
                  },
                  onTapOutside: (_) => _tappedOutsideText(),
                ),
                debounceDuration: Duration.zero,
                // To remove animation:
                transitionBuilder: (context, animation, child) => child,
                // To set them empty:
                hideOnEmpty: true,
                hideOnError: true,
                hideOnLoading: true,
                // Completions logic:
                suggestionsCallback: _getCompletions,
                onSelected: widget.onCompletionPressed,
                // Completions menu:
                decorationBuilder: (context, child) => Material(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(10),
                  color: QuimifyColors.foreground(context),
                  child: child,
                ),
                itemBuilder: (context, String completion) {
                  return Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Icon(
                            Icons.subdirectory_arrow_right_rounded,
                            size: 26,
                            color: QuimifyColors.primary(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: AutoSizeText(
                              widget.completionCorrector(completion),
                              maxLines: 1,
                              stepGranularity: 0.1,
                              style: TextStyle(
                                color: QuimifyColors.primary(context),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          QuimifyIconButton.square(
            height: 50,
            backgroundColor: QuimifyColors.foreground(context),
            onPressed: () => _cameraHandler.handleCameraButton(
              context,
              _handleExtractedText,
            ),

            // onPressed: () => comingSoonDialog.show(context),
            icon: Icon(
              Icons.camera_alt_outlined,
              color: QuimifyColors.primary(context),
            ),
          ),
        ],
      ),
    );
  }
}
