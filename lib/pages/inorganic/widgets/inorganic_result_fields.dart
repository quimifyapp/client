import 'package:flutter/material.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_result_field.dart';

class InorganicResultFields extends StatelessWidget {
  const InorganicResultFields({
    Key? key,
    required this.fields,
  }) : super(key: key);

  final List<InorganicResultField> fields;

  @override
  Widget build(BuildContext context) {
    // Not empty fields:
    int fieldsLength = fields.where((field) => field.quantity != null).length;

    return fieldsLength == 0
        ? Container()
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.onSurface,
            ),
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 50,
                      child: fields[0],
                    ),
                    if (fieldsLength > 1) ...[
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 50,
                        child: fields[1],
                      ),
                    ],
                  ],
                ),
                if (fieldsLength > 2) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 50,
                        child: fields[2],
                      ),
                      if (fieldsLength > 3) ...[
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 50,
                          child: fields[3],
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          );
  }
}
