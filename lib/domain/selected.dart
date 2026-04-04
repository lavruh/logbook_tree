import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected.g.dart';

@riverpod
class Selected extends _$Selected {
  @override
  List<String> build() {
    state = [];
    return [];
  }

  void setState(List<String> val) {
    state = [...val];
  }

  void select(String val) {
    if (isSelected(val)) return;
    state = [...state, val];
  }

  void unselect(String val) {
    if (!isSelected(val)) return;
    state.remove(val);
    state = [...state];
  }

  void toggle(String val) {
    if (isSelected(val)) {
      unselect(val);
    } else {
      select(val);
    }
  }

  void clear() => state = [];

  bool isSelected(String val) => state.contains(val);
}
