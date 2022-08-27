import 'package:cliente/widgets/margined_column.dart';
import 'package:cliente/widgets/margined_row.dart';
import 'package:flutter/material.dart';

class PageAppBar extends StatelessWidget {
  const PageAppBar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return MarginedRow(
      margin: 25,
      child: MarginedColumn(
        top: 15,
        bottom: 25,
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.white,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () => Navigator.of(context).pop(),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 106, 233, 218),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
