
import 'package:logbook_tree/domain/logbook_entry.dart';

abstract class LogbookData {
  Stream<LogbookEntry> getLogbookEntries({required String sourcePath});
  Future<void> updateLogbookEntry({required LogbookEntry updatedEntry});
  Future<void> deleteLogbookEntry({required LogbookEntry entry});
}