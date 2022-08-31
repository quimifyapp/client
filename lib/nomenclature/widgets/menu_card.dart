import 'package:flutter/material.dart';

import '../../widgets/constants.dart';

class MenuCard extends StatelessWidget {
  const MenuCard(
      {Key? key,
      this.width,
      required this.title,
      required this.structure,
      required this.name,
      required this.page})
      : _custom = false,
        _locked = false,
        customBody = null;

  const MenuCard.custom(
      {Key? key,
      this.width,
      required this.title,
      required this.customBody,
      required this.page})
      : _custom = true,
        _locked = false,
        name = null,
        structure = null;

  const MenuCard.locked({Key? key, this.width, required this.title})
      : _custom = false,
        _locked = true,
        customBody = null,
        structure = null,
        name = null,
        page = null;

  final double? width;

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
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_custom) {
      body = customBody!;
    } else if (_locked) {
      body = Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/icons/lock.png',
                height: 35,
                color: const Color.fromARGB(255, 70, 70, 70),
              ),
            ),
            const SizedBox(height: 12),
            Center(child: _nameFor('Próximamente')),
          ],
        ),
      );
    } else {
      body = Container(
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, left: 25, right: 25),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              structure!,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: quimifyTeal,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: page != null
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return page!;
                  },
                ),
              );
            }
          : () {},
      child: Container(
        width: width,
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
              padding: const EdgeInsets.only(
                  top: 17, bottom: 13, left: 25, right: 25),
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body,
          ],
        ),
      ),
    );
  }
}
