import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logbook_tree/domain/selected.dart';

import '../domain/tags_provider.dart';

class TagsSelectWidget extends ConsumerWidget {
  const TagsSelectWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagsProvider);
    final selected = ref.watch(selectedProvider);

    return tags.when(
      data: (d) {
        List<Widget> tagsList = [];

        Map<String, List<String>> tagsByGroup = {};
        for (final tag in d) {
          final group = tag.substring(1, 2);
          if (tagsByGroup[group] == null) {
            tagsByGroup[group] = [];
          }
          tagsByGroup[group]!.add(tag);
        }

        tagsByGroup.forEach((group, tags) {
          tagsList.add(
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.toUpperCase(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 3,
                    runSpacing: 3,
                    children: tags.map((tag) {
                      return ChoiceChip(
                        selected: selected.contains(tag),
                        onSelected: (v) =>
                            ref.read(selectedProvider.notifier).toggle(tag),
                        label: Text(tag),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        });
        return ListView(children: tagsList);
      },
      error: (e, s) => Text(e.toString()),
      loading: () => CircularProgressIndicator(),
    );
  }
}
