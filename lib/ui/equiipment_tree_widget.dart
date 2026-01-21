import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logbook_tree/domain/equipment_tree_provider.dart';
import 'package:logbook_tree/domain/selected.dart';

class EquipmentTree extends ConsumerStatefulWidget {
  const EquipmentTree({super.key});

  @override
  ConsumerState<EquipmentTree> createState() => _EquipmentTreeState();
}

class _EquipmentTreeState extends ConsumerState<EquipmentTree> {
  Widget _treeNodeBuilder(
    BuildContext context,
    TreeSliverNode<Object?> node,
    AnimationStyle toggleAnimationStyle,
  ) {
    final bool isParentNode = node.children.isNotEmpty;
    final equipmentNode = node.content as EquipmentNode;

    return TreeSliver.wrapChildToToggleNode(
      node: node,
      child: Row(
        children: <Widget>[
          // Custom indentation
          SizedBox(width: 40.0 * node.depth!),

          if (isParentNode)
            DecoratedBox(
              decoration: BoxDecoration(border: Border.all()),
              child: SizedBox.square(
                dimension: 12.0,
                child: Icon(
                  node.isExpanded ? Icons.remove : Icons.add,
                  size: 12,
                ),
              ),
            ),
          // Spacer
          const SizedBox(width: 8.0),
          // Content
          TextButton(
            onPressed: () {
              final equipmentNode = node.content as EquipmentNode;
              ref.read(selectedProvider.notifier).setState(equipmentNode.tags);
            },
            child: Text(equipmentNode.title, style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tree = ref.watch(equipmentTreeProvider);
    return CustomScrollView(
      slivers: <Widget>[
        TreeSliver<EquipmentNode>(
          tree: tree,
          onNodeToggle: (TreeSliverNode<Object?> node) {},
          treeNodeBuilder: _treeNodeBuilder,
          treeRowExtentBuilder:
              (
                TreeSliverNode<Object?> node,
                SliverLayoutDimensions layoutDimensions,
              ) => 30.0,
          // No internal indentation, the custom treeNodeBuilder applies its
          // own indentation to decorate in the indented space.
          indentation: TreeSliverIndentationType.none,
        ),
      ],
    );
  }
}
