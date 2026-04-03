import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:docx_to_text/docx_to_text.dart';

import 'package:logbook_tree/data/i_data_file_parser.dart';
import 'package:logbook_tree/domain/logbook_entry.dart';
import 'package:logbook_tree/domain/messenger.dart';

class DocxDataFileParser implements IDataFileParser {
  @override
  late final Messenger messenger;

  DocxDataFileParser({required this.messenger});

  @override
  bool isCorrectExtension(File f) {
    final extension = p.extension(f.path);
    return extension.contains("docx");
  }

  @override
  Stream<LogbookEntry> parseFile(File f) async* {
    final bytes = await f.readAsBytes();
    final text = docxToText(bytes);
    final filePath = f.path;

    final lines = text.split('\n');

    DateTime? currentDate;
    final currentEntries = <String>[];

    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      final dateMatch = RegExp(
        r'(\w+day),?\s+\d{1,2}\s+\w+\s+\d{4}',
      ).firstMatch(trimmedLine);

      if (dateMatch != null) {
        // Save previous entries if any
        if (currentDate != null && currentEntries.isNotEmpty) {
          for (final entry in currentEntries) {
            yield LogbookEntry(
              sourceName: filePath,
              date: currentDate,
              text: entry,
              tags: [],
            );
          }
          currentEntries.clear();
        }

        // Parse new date
        currentDate = _parseDate(trimmedLine);
      } else if (currentDate != null) {
        // This is an entry line for the current date
        if (trimmedLine.isNotEmpty) {
          currentEntries.add(trimmedLine);
        }
      }
    }

    // Save remaining entries
    if (currentDate != null && currentEntries.isNotEmpty) {
      for (final entry in currentEntries) {
        yield LogbookEntry(
          sourceName: p.basename(filePath),
          date: currentDate,
          text: entry,
          tags: [],
        );
      }
    }
  }

  DateTime _parseDate(String dateText) {
    final match = RegExp(
      r'(\w+day),?\s+(\d{1,2})\s+(\w+)\s+(\d{4})',
    ).firstMatch(dateText);
    if (match != null) {
      final day = int.parse(match.group(2)!);
      final month = _parseMonth(match.group(3)!);
      final year = int.parse(match.group(4)!);
      return DateTime(year, month, day);
    }

    return DateTime.now();
  }

  int _parseMonth(String monthName) {
    final months = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };
    return months[monthName] ?? 1;
  }
}
