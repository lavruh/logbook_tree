import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logbook_tree/domain/app_dir_provider.dart';
import 'package:logbook_tree/domain/text_filter_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as p;

part 'tags_provider.g.dart';

@riverpod
Future<List<String>> tags(Ref ref) async {
  List<String> tags = [];

  ref
      .watch(appDirProvider)
      .when(
        data: (val) async {
          final appDirPath = val.path;
          final tagsFilePath = p.join(appDirPath, "tags.yaml");
          final tagsFile = File(tagsFilePath);
          if (!tagsFile.existsSync()) {
            final tagsFileData = await rootBundle.loadString(
              'assets/tags.yaml',
            );
            tagsFile.writeAsStringSync(tagsFileData);
          }
          tags = tagsFile.readAsLinesSync();
        },
        error: (e, s) => throw e,
        loading: () {},
      );
  final textFilter = ref.watch(textFilterProvider);

  tags.sort((a, b) => a.compareTo(b));
  return tags.where((t) => t.contains(textFilter)).toList();
}
