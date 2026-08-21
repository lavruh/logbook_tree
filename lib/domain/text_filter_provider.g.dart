// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TextFilter)
final textFilterProvider = TextFilterProvider._();

final class TextFilterProvider extends $NotifierProvider<TextFilter, String> {
  TextFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'textFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$textFilterHash();

  @$internal
  @override
  TextFilter create() => TextFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$textFilterHash() => r'4572dae7d73e892c8591b084ac3e71ef341a0480';

abstract class _$TextFilter extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
