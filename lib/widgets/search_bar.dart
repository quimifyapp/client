import 'package:flutter/material.dart';

import 'margined_column.dart';
import 'margined_row.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key? key, required this.hint, required this.corrector})
      : super(key: key);

  final String hint;
  final Function(String) corrector;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MarginedRow.center(
      margin: 25,
      child: Expanded(
        child: MarginedColumn(
          top: 5,
          bottom: 30,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: TextField(
                      // Aspect:
                      cursorColor: Color.fromARGB(255, 34, 34, 34),
                      style: TextStyle(
                          color: Color.fromARGB(255, 34, 34, 34), fontSize: 18),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        // So vertical center works:
                        isCollapsed: true,
                        labelText: widget.hint,
                        // So hint doesn't go up while typing:
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        // To remove bottom border:
                        border: OutlineInputBorder(
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
                              color: Color.fromARGB(255, 34, 34, 34),
                            ),
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {},
                          ),
                        ),
                      ),
                      // Logic:
                      textInputAction: TextInputAction.done,
                      controller: _controller,
                      onChanged: (String input) {
                        _controller.value = _controller.value.copyWith(
                          text: widget.corrector(input),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Container(
                height: 48,
                width: 48,
                child: IconButton(
                  icon: Icon(Icons.camera_alt_outlined),
                  color: Color.fromARGB(255, 34, 34, 34),
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {},
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
