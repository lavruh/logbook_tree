import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messenger.g.dart';

@Riverpod(keepAlive: true)
class Messenger extends _$Messenger {
  @override
  String build() {
    state = "";
    return "";
  }

  void println(String message) => state += "$message\n";

  void clear() => state = "";
}
