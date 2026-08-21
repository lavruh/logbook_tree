import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logbook_tree/data/ollama_tagger_service.dart';
import 'package:logbook_tree/domain/logbook_entry.dart';
import 'package:logbook_tree/domain/logbook_provider.dart';
import 'package:logbook_tree/domain/messenger.dart';
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
  bool _isGeneratingTags = false;
  OllamaTaggerService? _taggerService;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.entry.text);
    _selectedDate = widget.entry.date;
    _tags = List.from(widget.entry.tags);
    _initializeTaggerService();
  }

  Future<void> _initializeTaggerService() async {
    final messenger = ref.read(messengerProvider.notifier);
    final availableTags = await ref.read(tagsProvider.future);
    
    _taggerService = OllamaTaggerService(
      messenger: messenger,
      availableTags: availableTags,
    );
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

  void _deleteEntry() {
    ref.read(logbookProvider.notifier).deleteLogbookEntry(entry: widget.entry);
    Navigator.of(context).pop();
  }

  Future<void> _generateTags() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text first')),
      );
      return;
    }

    if (_taggerService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tagger service not initialized')),
      );
      return;
    }

    setState(() {
      _isGeneratingTags = true;
    });

    try {
      final extractedTags = await _taggerService!.extractTags(text);
      
      setState(() {
        _tags = extractedTags;
        _isGeneratingTags = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Generated ${extractedTags.length} tags')),
      );
    } catch (e) {
      setState(() {
        _isGeneratingTags = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating tags: $e')),
      );
    }
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
            const SizedBox(height: 16),

            // Generate tags button
            ElevatedButton(
              onPressed: _isGeneratingTags ? null : _generateTags,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
              ),
              child: _isGeneratingTags
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Generating tags...'),
                      ],
                    )
                  : const Text(
                      'Generate tags from text',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
            const Spacer(),

            // Delete and Save buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Entry'),
                            content: const Text('Are you sure you want to delete this entry?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _deleteEntry();
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context).colorScheme.error,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
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
          ],
        ),
      ),
    );
  }
}