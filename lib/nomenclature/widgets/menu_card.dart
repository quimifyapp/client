import 'package:flutter/material.dart';

import '../../widgets/constants.dart';
import '../../widgets/margined_column.dart';
import '../../widgets/margined_row.dart';

class MenuCard extends StatelessWidget {
  const MenuCard(
      {Key? key,
      required this.title,
      required this.structure,
      required this.name,
      required this.page})
      : _custom = false,
        _locked = false,
        customBody = null;

  const MenuCard.custom(
      {Key? key,
      required this.title,
      required this.customBody,
      required this.page})
      : _custom = true,
        _locked = false,
        name = null,
        structure = null;

  const MenuCard.locked({Key? key, required this.title})
      : _custom = false,
        _locked = true,
        customBody = null,
        structure = null,
        name = null,
        page = null;

  final String title;
  final Widget? customBody;
  final String? structure;
  final String? name;
  final Widget? page;

  final bool _custom;
  final bool _locked;

  static Text _nameFor(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_custom)
      body = customBody!;
    else if (_locked)
      body = MarginedColumn.center(
        margin: 15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/icons/lock.png',
                height: 35,
                color: Color.fromARGB(255, 70, 70, 70),
              ),
            ),
            SizedBox(height: 12),
            Center(child: _nameFor('Próximamente')),
          ],
        ),
      );
    else
      body = MarginedColumn.center(
        margin: 15,
        child: MarginedRow.center(
          margin: 25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                structure!,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: quimifyTeal,
                ),
              ),
              SizedBox(height: 12),
              Text(
                name!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );

    return InkWell(
      child: Container(
        width: 290,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        // To avoid rounded corners overflow:
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Container(
              decoration: quimifyGradientBoxDecoration,
              child: MarginedColumn(
                top: 17,
                bottom: 13,
                child: MarginedRow.center(
                  margin: 25,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            body,
          ],
        ),
      ),
      onTap: (page == null)
          ? () {}
          : () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return page!;
                  },
                ),
              );
            },
    );
  }
}
