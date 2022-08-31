import 'package:flutter/material.dart';


class SectionTitle extends StatelessWidget {
  const SectionTitle({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.help_outline),
            // To remove padding:
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
