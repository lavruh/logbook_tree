import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:langchain/langchain.dart';
import 'package:langchain_ollama/langchain_ollama.dart';

import 'package:logbook_tree/data/i_tagger_service.dart';
import 'package:logbook_tree/domain/messenger.dart';

extension ChatOllamaOptionsExtension on ChatOllamaOptions {
  static ChatOllamaOptions loadFromJson(Map<String, dynamic> json) {
    return ChatOllamaOptions(
      model: json['model'] as String?,
      format: json['format'] != null
          ? OllamaResponseFormat.values.firstWhere(
              (e) => e.name == json['format'],
              orElse: () => OllamaResponseFormat.json,
            )
          : null,
      keepAlive: json['keepAlive'] as int?,
      think: json['think'] != null
          ? OllamaThinkingLevel.values.firstWhere(
              (e) => e.name == json['think'],
              orElse: () => OllamaThinkingLevel.medium,
            )
          : null,
      numKeep: json['numKeep'] as int?,
      seed: json['seed'] as int?,
      numPredict: json['numPredict'] as int?,
      topK: json['topK'] as int?,
      topP: json['topP'] as double?,
      minP: json['minP'] as double?,
      tfsZ: json['tfsZ'] as double?,
      typicalP: json['typicalP'] as double?,
      repeatLastN: json['repeatLastN'] as int?,
      temperature: json['temperature'] as double?,
      repeatPenalty: json['repeatPenalty'] as double?,
      presencePenalty: json['presencePenalty'] as double?,
      frequencyPenalty: json['frequencyPenalty'] as double?,
      mirostat: json['mirostat'] as int?,
      mirostatTau: json['mirostatTau'] as double?,
      mirostatEta: json['mirostatEta'] as double?,
      penalizeNewline: json['penalizeNewline'] as bool?,
      stop: json['stop'] != null
          ? List<String>.from(json['stop'] as List)
          : null,
      numa: json['numa'] as bool?,
      numCtx: json['numCtx'] as int?,
      numBatch: json['numBatch'] as int?,
      numGpu: json['numGpu'] as int?,
      mainGpu: json['mainGpu'] as int?,
      lowVram: json['lowVram'] as bool?,
      f16KV: json['f16KV'] as bool?,
      logitsAll: json['logitsAll'] as bool?,
      vocabOnly: json['vocabOnly'] as bool?,
      useMmap: json['useMmap'] as bool?,
      useMlock: json['useMlock'] as bool?,
      numThread: json['numThread'] as int?,
    );
  }
}

class OllamaTaggerService implements ITaggerService {
  @override
  final Messenger messenger;

  @override
  List<String> availableTags;

  String availableTagsString = "";

  OllamaTaggerService({required this.messenger, required this.availableTags}) {
    _loadQueryTemplate();
    _loadChatOllamaOptions();
    availableTagsString = availableTags.join(',');
  }

  late final String? queryTemplateString;
  late final ChatOllamaOptions? chatOllamaOptions;

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
      defaultOptions: chatOllamaOptions ?? ChatOllamaOptions(model: 'gemma3:4b'),
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

  Future<void> _loadChatOllamaOptions() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/chat_ollama_options.json',
      );
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      chatOllamaOptions = ChatOllamaOptionsExtension.loadFromJson(jsonMap);
      messenger.println('ChatOllama options loaded successfully.');
      messenger.println('Model in use: "${chatOllamaOptions?.model}"');
    } catch (e) {
      messenger.println('Error loading ChatOllama options: $e');
    }
  }
}
