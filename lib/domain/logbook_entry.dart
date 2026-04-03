class LogbookEntry {
  final int uid;
  final DateTime date;
  final String text;
  final List<String> tags;
  final String sourceName;

  LogbookEntry({
    required this.date,
    required this.text,
    this.tags = const [],
    required this.sourceName,
  }) : uid = date.hashCode ^ text.hashCode;


  LogbookEntry copyWith({
    DateTime? date,
    String? text,
    List<String>? tags,
    String? sourceName,
  }) {
    return LogbookEntry(
      date: date ?? this.date,
      text: text ?? this.text,
      tags: tags ?? this.tags,
      sourceName: sourceName ?? this.sourceName,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'date': date.toIso8601String(),
      'text': text,
      'tags': tags,
      'sourceName': sourceName,
    };
  }

  factory LogbookEntry.fromMap(Map<String, dynamic> map) {
    return LogbookEntry(
      date: DateTime.parse(map['date']),
      text: map['text'],
      tags: List<String>.from(map['tags']),
      sourceName: map['sourceName'],
    );
  }
}
