// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tags)
final tagsProvider = TagsProvider._();

final class TagsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  TagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return tags(ref);
  }
}

String _$tagsHash() => r'd890070f0bd6ab21633c39ce2b5a093722b8b23f';

@ProviderFor(tagsFiltered)
final tagsFilteredProvider = TagsFilteredProvider._();

final class TagsFilteredProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  TagsFilteredProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagsFilteredProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagsFilteredHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return tagsFiltered(ref);
  }
}

String _$tagsFilteredHash() => r'16621b86c3840b9ac6fa71e091472cc0e9191c07';
