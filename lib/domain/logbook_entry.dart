class LogbookEntry {
  final DateTime date;
  final String text;

  LogbookEntry({required this.date, required this.text});

  LogbookEntry copyWith({DateTime? date, String? text}) {
    return LogbookEntry(date: date ?? this.date, text: text ?? this.text);
  }
}
