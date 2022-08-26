import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key, required this.hint}) : super(key: key);

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          // Search zone
          children: [
            Expanded(
                child: TextField(
              textInputAction: TextInputAction.done,
              cursorColor: Color.fromARGB(255, 34, 34, 34),
              style: TextStyle(color: Color.fromARGB(255, 34, 34, 34)),
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Transform.scale(
                      scale: 0.7,
                      child: IconButton(
                          icon: Image.asset('assets/images/icons/search.png',
                              color: Color.fromARGB(255, 34, 34, 34)),
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {})),
                  labelText: hint),
            )),
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
                    onPressed: () {}),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)))
          ],
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
