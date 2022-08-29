import 'package:flutter/material.dart';

import 'margined_column.dart';
import 'margined_row.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key? key, required this.hint, required this.corrector})
      : super(key: key);

  final String hint;
  final Function(String) corrector;

  final TextEditingController _controller = TextEditingController();

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
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
                  child: TextField(
                    // Aspect:
                    cursorColor: Color.fromARGB(255, 34, 34, 34),
                    style: TextStyle(
                      color: Color.fromARGB(255, 34, 34, 34),
                    ),
                    decoration: InputDecoration(
                      labelText: widget.hint,
                      // So hint doesn't go up while typing:
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.only(top: 35),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
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
                    controller: widget._controller,
                    onChanged: (String input) {
                      widget._controller.value =
                          widget._controller.value.copyWith(
                        text: widget.corrector(input),
                      );
                    },
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
