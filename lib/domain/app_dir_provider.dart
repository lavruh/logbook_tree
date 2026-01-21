import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_dir_provider.g.dart';

@riverpod
Future<Directory> appDir(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  final dirPath = prefs.getString("app_data_dir");
  if(dirPath == null) throw Exception("Data directory is not set");
  final dir = Directory(dirPath);
   if(!dir.existsSync()) throw Exception("Cannot open documents directory");
  return dir;
}
