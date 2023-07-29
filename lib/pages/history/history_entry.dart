class HistoryEntry {
  const HistoryEntry({
    required this.query,
    required this.fields,
  });

  final dynamic query;
  final Map<String, String?> fields;
}
