import 'package:quimify_client/pages/history/history_field.dart';

class HistoryEntry {
  const HistoryEntry({
    required this.query,
    required this.fields,
  });

  final dynamic query;
  final List<HistoryField> fields;
}
