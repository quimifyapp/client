import 'package:flutter/material.dart';
import 'package:quimify_client/pages/history/history_entry.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_field.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:signed_spacing_flex/signed_spacing_flex.dart';

class HistoryEntryView extends StatelessWidget {
  const HistoryEntryView({
    Key? key,
    required this.entry,
    required this.onPressed,
  }) : super(key: key);

  final HistoryEntry entry;
  final void Function(dynamic) onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: QuimifyColors.foreground(context),
      ),
      // To avoid rounded corners overflow:
      clipBehavior: Clip.hardEdge,
      child: MaterialButton(
        padding: const EdgeInsets.all(20),
        splashColor: Colors.transparent,
        onPressed: () => onPressed(entry.query),
        child: Row(
          children: [
            Expanded(
              child: SignedSpacingColumn(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: entry.fields
                    .map(
                      (field) => QuimifyField(
                        title: field.title,
                        titleColor: QuimifyColors.teal(),
                        value: field.value,
                        valueBold: false,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(width: 15),
            Icon(
              Icons.arrow_forward_rounded,
              size: 30,
              color: QuimifyColors.teal(),
            ),
          ],
        ),
      ),
    );
  }
}
