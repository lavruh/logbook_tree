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
    final availableTags = ref.watch(tagsProvider).value;
    final messenger = ref.read(messengerProvider.notifier);
    if(availableTags == null) return;
    final logbookData = DbLogbookData(
      messenger: ref.read(messengerProvider.notifier),
      dataParser: DocxDataFileParser(messenger: messenger),
      tagger: OllamaTaggerService(messenger: messenger, availableTags: availableTags),
    );
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
