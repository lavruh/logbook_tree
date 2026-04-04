import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'text_filter_provider.g.dart';

@riverpod
class TextFilter extends _$TextFilter {
  @override
  String build() => "";

  void filter(String val) => state = val;
  void clear() => state = "";
}
