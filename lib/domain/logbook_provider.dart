import 'dart:io';

import 'package:logbook_tree/data/rednote_logbook_data.dart';
import 'package:logbook_tree/domain/app_dir_provider.dart';
import 'package:logbook_tree/domain/datetime_extension.dart';
import 'package:logbook_tree/domain/logbook_entry.dart';
import 'package:logbook_tree/domain/selected.dart';
import 'package:logbook_tree/domain/text_filter_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logbook_provider.g.dart';

@riverpod
class Logbook extends _$Logbook {
  @override
  List<LogbookEntry> build() {
    ref.watch(appDirProvider).whenData((dir) {
      loadLogbookFromDirectory(dir);
    });
    return [];
  }

  Future<void> loadLogbookFromDirectory(Directory dir) async {
    final logbookData = RednoteLogbookData();
    await for (final entry in logbookData.getLogbookEntries(
      sourcePath: dir.path,
    )) {
      state = [...state, entry];
    }
  }
}

@riverpod
List<LogbookEntry> filteredLogbook(Ref ref) {
  final selectedTags = ref.watch(selectedProvider);
  final logbook = ref.watch(logbookProvider);
  final searchString = ref.watch(textFilterProvider);
  List<LogbookEntry> entries = [];

  entries = logbook.where((e) {
    return selectedTags.every((tag) => e.text.contains(tag));
  }).toList();

  if (searchString.isNotEmpty) {
    entries = entries.where((e) => e.text.contains(searchString)).toList();
  }

  final result = selectedTags.isNotEmpty || searchString.isNotEmpty
      ? entries
      : logbook;

  result.sort((a, b) {
    return b.date.compareDateTo(a.date);
  });

  return result;
}
