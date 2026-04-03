import 'package:logbook_tree/domain/messenger.dart';

abstract class ITaggerService {
  final Messenger messenger;
  List<String> availableTags;

  ITaggerService({required this.messenger, required this.availableTags});
  Future<List<String>> extractTags(String text);
}

class TaggerServiceException implements Exception {
  final String message;
  TaggerServiceException(this.message);


  @override
  String toString() {
    return 'TaggerServiceException{$message}';
  }
}
