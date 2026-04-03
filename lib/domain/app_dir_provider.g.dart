// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_dir_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDir)
final appDirProvider = AppDirProvider._();

final class AppDirProvider
    extends
        $FunctionalProvider<
          AsyncValue<Directory>,
          Directory,
          FutureOr<Directory>
        >
    with $FutureModifier<Directory>, $FutureProvider<Directory> {
  AppDirProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDirProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDirHash();

  @$internal
  @override
  $FutureProviderElement<Directory> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Directory> create(Ref ref) {
    return appDir(ref);
  }
}

String _$appDirHash() => r'b015843788e2cd610276bf6790d02a819503e93d';
