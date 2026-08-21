// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_tree_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EquipmentTree)
final equipmentTreeProvider = EquipmentTreeProvider._();

final class EquipmentTreeProvider
    extends
        $NotifierProvider<EquipmentTree, List<TreeSliverNode<EquipmentNode>>> {
  EquipmentTreeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'equipmentTreeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$equipmentTreeHash();

  @$internal
  @override
  EquipmentTree create() => EquipmentTree();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TreeSliverNode<EquipmentNode>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TreeSliverNode<EquipmentNode>>>(
        value,
      ),
    );
  }
}

String _$equipmentTreeHash() => r'0c3fa4bfa27296c7525d7665cc6efe6801bb72ab';

abstract class _$EquipmentTree
    extends $Notifier<List<TreeSliverNode<EquipmentNode>>> {
  List<TreeSliverNode<EquipmentNode>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              List<TreeSliverNode<EquipmentNode>>,
              List<TreeSliverNode<EquipmentNode>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                List<TreeSliverNode<EquipmentNode>>,
                List<TreeSliverNode<EquipmentNode>>
              >,
              List<TreeSliverNode<EquipmentNode>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
