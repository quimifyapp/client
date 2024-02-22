import 'package:flutter/material.dart';
import 'package:quimify_client/pages/inorganic/widgets/inorganic_result_field.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';

class InorganicResultFields extends StatelessWidget {
  const InorganicResultFields({
    Key? key,
    required this.fields,
  }) : super(key: key);

  final List<InorganicResultField> fields;

  @override
  Widget build(BuildContext context) {
    // Not empty fields:
    int fieldsCount = fields.where((field) => field.quantity != null).length;

    if (fieldsCount == 0) {
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: QuimifyColors.textHighlight(context),
      ),
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 50,
                child: fields[0],
              ),
              if (fieldsCount > 1) ...[
                const SizedBox(width: 20),
                Expanded(
                  flex: 50,
                  child: fields[1],
                ),
              ],
            ],
          ),
          if (fieldsCount > 2) ...[
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  flex: 50,
                  child: fields[2],
                ),
                if (fieldsCount > 3) ...[
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
