import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logbook_tree/data/i_logbook_data.dart';
import 'package:logbook_tree/domain/logbook_entry.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart' as p;

/// Parses a text with bullet points into a stream of individual entries.
///
/// Each entry starts with '•\t' and ends with '\n'. The function trims whitespace
/// from both ends of each entry and skips any empty entries.
Stream<String> _textToEntriesParser(String text) async* {
  // Split by bullet points and process each entry
  final entries = text.split("•");

  for (final entry in entries) {
    if (entry.contains("text: ")) continue;
    final newlineIndex = entry.indexOf('\\n');
    String entryText = entry;

    if (newlineIndex != -1) {
      entryText = entry.substring(0, newlineIndex).trim();
    }

    if (entryText.isNotEmpty) {
      yield entryText.replaceAll("\\t", "");
    }
  }
}

class RednoteLogbookData implements LogbookData {
  @override
  Stream<LogbookEntry> getLogbookEntries({required String sourcePath}) async* {
    final directory = Directory(sourcePath);
    if (!await directory.exists()) {
      throw Exception('Directory does not exist: $sourcePath');
    }

    // Get all .txt files matching the yyyy-MM.txt pattern
    final fileRegExp = RegExp(r'^\d{4}-\d{2}\.txt');
    final dir = Directory(sourcePath);
    await for (final entry in dir.list()) {
      if (entry is! File) continue;
      final file = entry;
      final fileName = path.basename(file.path);
      debugPrint("Process file >> $fileName");
      if (!fileRegExp.hasMatch(fileName)) continue;
      final fileNameParts = path.basenameWithoutExtension(file.path).split('-');
      final year = int.parse(fileNameParts[0]);
      final month = int.parse(fileNameParts[1]);

      try {
        yield* _parseLogFile(file: file, date: DateTime(year, month, 1));
      } catch (e) {
        debugPrint('Error processing file ${file.path}: $e');
        debugPrintStack();
      }
    }
  }

  @override
  Future<void> deleteLogbookEntry({required LogbookEntry entry}) {
    // TODO: implement deleteLogbookEntry
    throw UnimplementedError();
  }

  @override
  Future<void> updateLogbookEntry({required LogbookEntry updatedEntry}) {
    // TODO: implement updateLogbookEntry
    throw UnimplementedError();
  }
}

Stream<LogbookEntry> _parseLogFile({
  required File file,
  required DateTime date,
}) async* {
  final content = await file.readAsLines();
  int day = 0;
  final year = date.year;
  final month = date.month;

  String text = "";
  final dayRegExp = RegExp(r'^\d{1,2}\:$');

  for (final entry in content) {
    if (dayRegExp.hasMatch(entry)) {
      if (day > 0 && text.isNotEmpty) {
        await for (final entryText in _textToEntriesParser(text)) {
          yield LogbookEntry(
            date: DateTime(year, month, day),
            text: entryText,
            sourceName: p.basename(file.path),
          );
        }
      }

      day = int.parse(entry.replaceAll(":", ""));
      text = "";
      continue;
    }

    text += entry;
  }
}
