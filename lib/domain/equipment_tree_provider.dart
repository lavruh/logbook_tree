import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:logbook_tree/domain/app_dir_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as p;

part 'equipment_tree_provider.g.dart';

@riverpod
class EquipmentTree extends _$EquipmentTree {
  @override
  List<TreeSliverNode<EquipmentNode>> build() {
    List<TreeSliverNode<EquipmentNode>> tree = [];

    ref
        .watch(appDirProvider)
        .when(
          data: (val) async {
            final appDirPath = val.path;
            final filePath = p.join(appDirPath, "equipment_tree.json");

            try {
              final file = File(filePath);
              if (!await file.exists()) {
                final assetFileData = await rootBundle.loadString(
                  'assets/equipment_tree.json',
                );
                file.writeAsStringSync(assetFileData);
                return [];
              }

              final jsonString = await file.readAsString();
              final Map<String, dynamic> jsonData = jsonDecode(jsonString);

              final t = _buildTreeNodes(jsonData);
              state = t;
            } catch (e) {
              debugPrint('Error reading equipment tree: $e');
              return [];
            }
          },
          error: (e, s) => throw e,
          loading: () {},
        );

    return tree;
  }

  List<TreeSliverNode<EquipmentNode>> _buildTreeNodes(
    Map<String, dynamic> data,
  ) {
    List<TreeSliverNode<EquipmentNode>> result = [];
    for (final entry in data.entries) {
      try {
        final nodeData = entry.value as Map<String, dynamic>;
        final title = entry.key;
        final tags = (nodeData['tags'] as List<dynamic>).cast<String>();
        final childrenMap = nodeData['children'] as Map<String, dynamic>? ?? {};

        final node = TreeSliverNode<EquipmentNode>(
          EquipmentNode(title: title, tags: tags),
          children: _buildTreeNodes(childrenMap),
        );
        result.add(node);
      } catch (e) {
        debugPrint(e.toString());
        continue;
      }
    }

    return result;
  }
}

class EquipmentNode {
  final String title;
  final List<String> tags;
  EquipmentNode({required this.title, required this.tags});
}
