import 'dart:io';

import 'package:logbook_tree/domain/logbook_entry.dart';
import 'package:logbook_tree/domain/messenger.dart';

abstract class IDataFileParser {
  final Messenger messenger;

  IDataFileParser({required this.messenger});

  bool isCorrectExtension(File f);
  Stream<LogbookEntry> parseFile(File f);
}
