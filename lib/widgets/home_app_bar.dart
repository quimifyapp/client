import 'package:cliente/widgets/margined_column.dart';
import 'package:cliente/widgets/margined_row.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key, required this.title}) : super(key: key);

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return MarginedRow.center(
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
                  'assets/images/icons/logo.png',
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
            // Could be text or an image:
            title,
          ],
        ),
      ),
    );
  }
}
