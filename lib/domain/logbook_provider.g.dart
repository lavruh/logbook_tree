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
        isAutoDispose: true,
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

String _$logbookHash() => r'87b9c76735a5ac7bfa0af037dfae34649d97a159';

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

String _$filteredLogbookHash() => r'e59fa0d20783a93ee114d08a57b5ef6085a39b16';
