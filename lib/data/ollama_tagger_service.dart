import 'package:flutter/services.dart';

import 'package:langchain/langchain.dart';
import 'package:langchain_ollama/langchain_ollama.dart';

import 'package:logbook_tree/data/i_tagger_service.dart';
import 'package:logbook_tree/domain/messenger.dart';

class OllamaTaggerService implements ITaggerService {
  @override
  final Messenger messenger;

  @override
  List<String> availableTags;

  String availableTagsString = "";

  OllamaTaggerService({required this.messenger, required this.availableTags}) {
    _loadQueryTemplate();
    availableTagsString = availableTags.join(',');
  }

  late final String? queryTemplateString;

  @override
  Future<List<String>> extractTags(String text) async {
    final query = queryTemplateString;
    if (query == null) {
      throw TaggerServiceException(
        "Asset files are not loaded. Check log. Reinstall app",
      );
    }

    messenger.println("\nQuery : $text");

    final promptTemplate = ChatPromptTemplate.fromTemplates([
      (ChatMessageType.system, query),
      (ChatMessageType.human, '{question}'),
    ]);

    final prompt = promptTemplate.format({
      'context': availableTags,
      'question': text,
    });
    final promptValue = PromptValue.string(prompt);

    final chatModel = ChatOllama(
      defaultOptions: const ChatOllamaOptions(model: 'gemma3:4b'),
    );

    try {
      final answer = await chatModel.invoke(promptValue);
      final tagsString = answer.outputAsString;
      messenger.println("Answer : $tagsString");

      final tagsList = tagsString.split(',').map((e) => e.trim()).toList();


      final cleanedTags = _cleanUpTagsList(tagsList, availableTagsString);
      messenger.println("Tags list : $cleanedTags");
      return cleanedTags;
    } catch (e) {
      throw TaggerServiceException("Ollama client error: $e");
    }
  }

  List<String> _cleanUpTagsList(List<String> tagsList, String availableTags) {

    return tagsList.where((tag) => availableTags.contains(tag)).toList();
  }

  Future<void> _loadQueryTemplate() async {
    try {
      queryTemplateString = await rootBundle.loadString(
        'assets/query_template.txt',
      );
      messenger.println('Prompt template loaded successfully.');
    } catch (e) {
      messenger.println('Error loading prompt template: $e');
    }
  }
}
