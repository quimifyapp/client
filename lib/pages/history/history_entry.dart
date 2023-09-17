import 'package:quimify_client/pages/history/history_field.dart';

class HistoryEntry {
  const HistoryEntry({
    required this.query,
    required this.firstField,
    required this.secondField,
  });

  final dynamic query;
  final HistoryField firstField;
  final HistoryField? secondField;
}
