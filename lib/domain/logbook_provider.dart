import 'dart:io';

import 'package:logbook_tree/data/db_logbook_data.dart';
import 'package:logbook_tree/data/docx_data_file_parser.dart';
import 'package:logbook_tree/data/ollama_tagger_service.dart';
import 'package:logbook_tree/domain/app_dir_provider.dart';
import 'package:logbook_tree/domain/datetime_extension.dart';
import 'package:logbook_tree/domain/logbook_entry.dart';
import 'package:logbook_tree/domain/messenger.dart';
import 'package:logbook_tree/domain/selected.dart';
import 'package:logbook_tree/domain/tags_provider.dart';
import 'package:logbook_tree/domain/text_filter_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logbook_provider.g.dart';

@Riverpod(keepAlive: true)
class Logbook extends _$Logbook {
  late DbLogbookData _logbookData;
  late Messenger _messenger;
  bool isInit = false;

  @override
  List<LogbookEntry> build() {
    _messenger = ref.read(messengerProvider.notifier);
    ref.watch(appDirProvider).whenData((dir) {
      loadLogbookFromDirectory(dir);
    });
    return [];
  }

  Future<void> loadLogbookFromDirectory(Directory dir) async {
    final availableTags = ref.watch(tagsProvider).value;
    if (availableTags == null) return;
    if (!isInit) {
      _logbookData = DbLogbookData(
        messenger: ref.read(messengerProvider.notifier),
        dataParser: DocxDataFileParser(messenger: _messenger),
        tagger: OllamaTaggerService(
          messenger: _messenger,
          availableTags: availableTags,
        ),
      );
      isInit = true;
    }
    List<LogbookEntry> tmp = [];
    await for (final entry in _logbookData.getLogbookEntries(
      sourcePath: dir.path,
    )) {
      tmp = [...tmp, entry];
    }
    state = tmp;
  }

  Future<void> updateLogbookEntry({required LogbookEntry updatedEntry}) async {
    try {
      await _logbookData.updateLogbookEntry(updatedEntry: updatedEntry);

      final updatedEntries = state
          .where((e) => e.uid != updatedEntry.uid)
          .toList();
      updatedEntries.add(updatedEntry);
      state = updatedEntries;
    } catch (e) {
      _messenger.println("Error updating logbook entry: $e");
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
    return selectedTags.every((tag) => e.tags.contains(tag));
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
