// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messenger.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Messenger)
final messengerProvider = MessengerProvider._();

final class MessengerProvider extends $NotifierProvider<Messenger, String> {
  MessengerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messengerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messengerHash();

  @$internal
  @override
  Messenger create() => Messenger();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$messengerHash() => r'898f35a3c8478ecf2a00322a8eeeea4e3a208e9b';

abstract class _$Messenger extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
