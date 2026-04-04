import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logbook_tree/domain/logbook_entry.dart';
import 'package:logbook_tree/domain/tags_provider.dart';

class LogbookEntryEditor extends ConsumerStatefulWidget {
  final LogbookEntry entry;

  const LogbookEntryEditor({
    super.key,
    required this.entry,
  });

  @override
  ConsumerState<LogbookEntryEditor> createState() => _LogbookEntryEditorState();
}

class _LogbookEntryEditorState extends ConsumerState<LogbookEntryEditor> {
  late TextEditingController _textController;
  late DateTime _selectedDate;
  late List<String> _tags;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.entry.text);
    _selectedDate = widget.entry.date;
    _tags = List.from(widget.entry.tags);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_tags.contains(tag)) {
        _tags.remove(tag);
      } else {
        _tags.add(tag);
      }
    });
  }

  void _saveEntry() {
    final updatedEntry = LogbookEntry(
      uid: widget.entry.uid,
      date: _selectedDate,
      text: _textController.text.trim(),
      tags: _tags,
      sourceName: widget.entry.sourceName,
    );

    Navigator.of(context).pop(updatedEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Logbook Entry'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Date picker
            ListTile(
              title: const Text('Date'),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Text field
            const Text('Text:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter logbook entry text',
              ),
            ),
            const SizedBox(height: 16),

            // Tags section
            const Text('Tags:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Consumer(
              builder: (context, ref, child) {
                final availableTags = ref.watch(tagsProvider);
                return availableTags.when(
                  data: (tags) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: tags.map((tag) {
                        final isSelected = _tags.contains(tag);
                        return TextButton(
                          onPressed: () => _toggleTag(tag),
                          style: TextButton.styleFrom(
                            backgroundColor: isSelected 
                                ? Theme.of(context).colorScheme.primary
                                : null,
                            foregroundColor: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : null,
                          ),
                          child: Text(tag),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('Error loading tags: $error'),
                );
              },
            ),
            const Spacer(),

            // Save button
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: _saveEntry,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}