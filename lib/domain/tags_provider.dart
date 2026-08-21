import 'package:flutter/services.dart' show rootBundle;
import 'package:logbook_tree/domain/text_filter_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tags_provider.g.dart';

@riverpod
Future<List<String>> tags(Ref ref) async {
  List<String> tags = [];
  final tagsString = await rootBundle.loadString('assets/tags.yaml');
  tags = tagsString
      .split('\n')
      .map((String t) => t.replaceAll('\r', ''))
      .toList();
  tags.sort((a, b) => a.compareTo(b));
  return tags;
}

@riverpod
Future<List<String>> tagsFiltered(Ref ref) async {
  final textFilter = ref.watch(textFilterProvider);
  final tags = ref.watch(tagsProvider);
  if (textFilter.isEmpty) return tags.value ?? [];
  return tags.value?.where((t) => t.contains(textFilter)).toList() ?? [];
}
