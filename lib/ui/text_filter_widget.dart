import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logbook_tree/domain/text_filter_provider.dart';

class TextFilterWidget extends ConsumerWidget {
  const TextFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: TextField(
        onChanged: (value) =>
            ref.read(textFilterProvider.notifier).filter(value),
        decoration: InputDecoration(labelText: 'Filter'),
      ),
    );
  }
}
