// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logbook_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Logbook)
final logbookProvider = LogbookProvider._();

final class LogbookProvider
    extends $NotifierProvider<Logbook, List<LogbookEntry>> {
  LogbookProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logbookProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logbookHash();

  @$internal
  @override
  Logbook create() => Logbook();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<LogbookEntry> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<LogbookEntry>>(value),
    );
  }
}

String _$logbookHash() => r'760d77b51c319d7fce46a4be8f7adc923582d93a';

abstract class _$Logbook extends $Notifier<List<LogbookEntry>> {
  List<LogbookEntry> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<LogbookEntry>, List<LogbookEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<LogbookEntry>, List<LogbookEntry>>,
              List<LogbookEntry>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredLogbook)
final filteredLogbookProvider = FilteredLogbookProvider._();

final class FilteredLogbookProvider
    extends
        $FunctionalProvider<
          List<LogbookEntry>,
          List<LogbookEntry>,
          List<LogbookEntry>
        >
    with $Provider<List<LogbookEntry>> {
  FilteredLogbookProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredLogbookProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredLogbookHash();

  @$internal
  @override
  $ProviderElement<List<LogbookEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<LogbookEntry> create(Ref ref) {
    return filteredLogbook(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<LogbookEntry> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<LogbookEntry>>(value),
    );
  }
}

String _$filteredLogbookHash() => r'83c53388932acef5d996be015339c3c754b3ef3d';
