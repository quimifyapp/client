import 'package:cliente/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/text.dart';

class SearchBar extends StatefulWidget {
  const SearchBar(
      {Key? key,
      required this.label,
      required this.controller,
      required this.focusNode,
      required this.corrector,
      required this.onSubmitted})
      : super(key: key);

  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) corrector, onSubmitted;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  void _eraseInitialAndFinalBlanks() {
    setState(() {
      widget.controller.text = noInitialAndFinalBlanks(widget.controller.text);
    }); // Clears input
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 30, left: 25, right: 25),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Center(
                child: TextField(
                  // Aspect:
                  cursorColor: const Color.fromARGB(255, 34, 34, 34),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 34, 34, 34), fontSize: 18),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    // So vertical center works:
                    isCollapsed: true,
                    labelText: widget.label,
                    labelStyle: const TextStyle(
                      color: Colors.black45,
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
                        icon: Image.asset(
                          'assets/images/icons/search.png',
                          color: const Color.fromARGB(255, 34, 34, 34),
                        ),
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          widget.focusNode.unfocus();
                          _eraseInitialAndFinalBlanks();
                          widget.onSubmitted(widget.controller.text);
                        },
                      ),
                    ),
                  ),
                  // Logic:
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(inputFormatter),
                  ],
                  scribbleEnabled: false,
                  textInputAction: TextInputAction.search,
                  focusNode: widget.focusNode,
                  controller: widget.controller,
                  onChanged: (String input) => widget.controller.value =
                      widget.controller.value.copyWith(
                    text: widget.corrector(input),
                  ),
                  onSubmitted: (_) {
                    _eraseInitialAndFinalBlanks();
                    widget.onSubmitted(widget.controller.text);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Button(
            width: 50,
            color: Colors.white,
            onPressed: () {},
            child: const Icon(Icons.camera_alt_outlined,
                color: Color.fromARGB(255, 34, 34, 34)),
          ),
        ],
      ),
    );
  }
}
