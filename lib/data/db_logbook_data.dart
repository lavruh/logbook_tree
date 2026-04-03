import 'dart:io';

import 'package:logbook_tree/data/i_data_file_parser.dart';
import 'package:logbook_tree/data/i_logbook_data.dart';
import 'package:logbook_tree/data/i_tagger_service.dart';
import 'package:logbook_tree/domain/logbook_entry.dart';
import 'package:logbook_tree/domain/messenger.dart';
import 'package:path/path.dart' as p;
import 'package:sembast/sembast_io.dart';

class DbLogbookData implements LogbookData {
  Database? _database;
  late final StoreRef<int, Map<String, dynamic>> _logbookStore;
  final IDataFileParser dataParser;
  final ITaggerService tagger;

  final Messenger _messenger;

  DbLogbookData({
    required Messenger messenger,
    required this.dataParser,
    required this.tagger,
  }) : _messenger = messenger;

  @override
  Stream<LogbookEntry> getLogbookEntries({required String sourcePath}) async* {
    await _openDbIfNeed(sourcePath);
    _checkAndUpdateDb();
    final db = _database;
    if (db != null) {
      final entries = await _logbookStore.find(db);
      for (final entry in entries) {
        yield LogbookEntry.fromMap(entry.value);
      }
    }
  }

  Future<void> _openDbIfNeed(String sourcePath) async {
    final dbPath = p.join(sourcePath, 'logbook.db');
    if (!File(dbPath).existsSync()) {
      File(dbPath).createSync();
    }
    _database ??= await databaseFactoryIo.openDatabase(dbPath);
    if (_database != null) {
      _logbookStore = StoreRef<int, Map<String, dynamic>>('logbook');
    }
  }

  void _checkAndUpdateDb() async {
    final db = _database;
    if (db == null) return;
    final dataDirPath = p.join(p.dirname(db.path), 'data');
    final dataDir = Directory(dataDirPath);
    if (!dataDir.existsSync()) {
      dataDir.createSync(recursive: true);
    }
    for (final file in dataDir.listSync()) {
      if (!file.path.endsWith('.docx')) continue;
      if (file is File) {
        _messenger.println('Parsing file: ${file.path}');

        final entries = dataParser.parseFile(file);

        await for (final entry in entries) {
          if (await hasSameEntryInDb(entry.uid)) {
            _messenger.println('Entry already exists in database: ${entry.text}');
            continue;
          }
          try {
            final tags = await tagger.extractTags(entry.text);
            final taggedEntry = entry.copyWith(tags: tags);
            await _logbookStore.add(db, taggedEntry.toMap());
          } catch (e) {
            _messenger.println('Error parsing file: ${file.path}');
            _messenger.println('Error: $e');
            continue;
          }
        }
      }
    }
  }

  Future<bool> hasSameEntryInDb(int uid) async {
    final entry = await _logbookStore.findFirst(
      _database!,
      finder: Finder(filter: Filter.equals("uid", uid)),
    );
    return entry != null;
  }
}
