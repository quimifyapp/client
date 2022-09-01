import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key, required this.hint, required this.corrector})
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
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 30, left: 25, right: 25),
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
                    cursorColor: const Color.fromARGB(255, 34, 34, 34),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 34, 34, 34), fontSize: 18),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      // So vertical center works:
                      isCollapsed: true,
                      labelText: widget.hint,
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
            const SizedBox(width: 8),
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.camera_alt_outlined),
                color: const Color.fromARGB(255, 34, 34, 34),
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {},
              ),
            ),
          ],
        ),
    );
  }
}
