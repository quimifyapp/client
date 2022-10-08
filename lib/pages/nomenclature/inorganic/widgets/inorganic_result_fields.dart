import 'package:quimify_client/pages/nomenclature/inorganic/widgets/inorganic_result_field.dart';
import 'package:flutter/material.dart';

class InorganicResultFields extends StatelessWidget {
  const InorganicResultFields({Key? key, required this.fields})
      : super(key: key);

  final List<InorganicResultField> fields;

  @override
  Widget build(BuildContext context) {
    if (fields.isEmpty) {
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 50,
                child: fields[0],
              ),
              if (fields.length > 1) ...[
                const SizedBox(width: 20),
                Expanded(
                  flex: 50,
                  child: fields[1],
                ),
              ],
            ],
          ),
          if (fields.length > 2) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 50,
                  child: fields[2],
                ),
                if (fields.length > 3) ...[
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 50,
                    child: fields[3],
                  ),
                ],
              ],
            )
          ],
        ],
      ),
    );
  }
}
