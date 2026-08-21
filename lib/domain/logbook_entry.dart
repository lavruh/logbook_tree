class LogbookEntry {
  final int uid;
  final DateTime date;
  final String text;
  final List<String> tags;
  final String sourceName;

  LogbookEntry({
    int? uid,
    required this.date,
    required this.text,
    this.tags = const [],
    required this.sourceName,
  }) : uid = uid ?? generateUid(date: date, text: text);

  static int generateUid({required DateTime date, required String text}) {
    return date.hashCode ^ text.hashCode;
  }

  bool isUidCorrespondingToData() {
    return uid == generateUid(date: date, text: text);
  }


  LogbookEntry copyWith({
    DateTime? date,
    String? text,
    List<String>? tags,
    String? sourceName,
  }) {
    return LogbookEntry(
      uid: uid,
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
    final uid = map['uid'] is int ? map['uid'] : null;
    return LogbookEntry(
      uid: uid,
      date: DateTime.parse(map['date']),
      text: map['text'],
      tags: List<String>.from(map['tags']),
      sourceName: map['sourceName'],
    );
  }
}
