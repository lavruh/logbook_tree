
import 'package:logbook_tree/domain/logbook_entry.dart';

abstract class LogbookData {
  Stream<LogbookEntry> getLogbookEntries({required String sourcePath});
}