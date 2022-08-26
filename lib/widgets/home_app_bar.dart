import 'package:cliente/widgets/margined_column.dart';
import 'package:cliente/widgets/margined_row.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key, required this.title}) : super(key: key);

  final String title; // TODO: permitir el rótulo de las letras

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
                icon: Image.asset(
                  'assets/images/icons/quimify_dark.png',
                  color: Colors.white,
                ),
                // To remove native effects:
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                // So it fills container (48 x 48):
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () {},
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
