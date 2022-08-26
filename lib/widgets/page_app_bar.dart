import 'package:flutter/material.dart';

class PageAppBar extends StatelessWidget {
  const PageAppBar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: [
          SizedBox(height: 15),
          Row(
            children: [
              Container(
                  child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () => Navigator.of(context).pop()),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 106, 233, 218),
                      borderRadius: BorderRadius.circular(10))),
              SizedBox(width: 20),
              Text(
                'Formulación inorgánica',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
