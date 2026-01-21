// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Selected)
final selectedProvider = SelectedProvider._();

final class SelectedProvider extends $NotifierProvider<Selected, List<String>> {
  SelectedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedHash();

  @$internal
  @override
  Selected create() => Selected();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$selectedHash() => r'aab17e4660c38524884493e3dd25705b1cbc70f3';

abstract class _$Selected extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
