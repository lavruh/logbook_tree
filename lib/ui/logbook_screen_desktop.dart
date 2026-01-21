import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logbook_tree/domain/logbook_entry.dart';
import 'package:logbook_tree/domain/logbook_provider.dart';
import 'package:logbook_tree/domain/tags_provider.dart';
import 'package:logbook_tree/ui/equiipment_tree_widget.dart';
import 'package:logbook_tree/ui/settings_screen.dart';
import 'package:logbook_tree/ui/tags_select_widget.dart';
import 'package:logbook_tree/ui/text_filter_widget.dart';

import '../domain/datetime_extension.dart';

class LogbookScreenDesktop extends StatefulWidget {
  const LogbookScreenDesktop({super.key});

  @override
  State<LogbookScreenDesktop> createState() => _LogbookScreenDesktopState();
}

class _LogbookScreenDesktopState extends State<LogbookScreenDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFilterWidget(),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Row(
        children: [
          // Equipment Column
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey.shade300)),
              ),
              child: EquipmentTree(),
            ),
          ),

          // Logbook Column (main content)
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Consumer(
                builder: (context, ref, _) {
                  final data = ref.watch(filteredLogbookProvider);
                  List<Widget> children = _generateLogView(data);

                  return SelectionArea(child: ListView(children: children));
                },
              ),
            ),
          ),

          // Tags Column
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Flexible(
                child: Consumer(
                  builder: (context, ref, _) {
                    return ref
                        .watch(tagsProvider)
                        .when(
                          data: (data) {
                            return TagsSelectWidget();
                          },
                          error: (obj, stack) => Text(obj.toString()),
                          loading: () => CircularProgressIndicator(),
                        );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _generateLogView(List<LogbookEntry> data) {
    List<Widget> children = [];

    DateTime? lastItemDate;
    for (final e in data) {
      if (lastItemDate != null) {
        if (e.date.month != lastItemDate.month) {
          children.add(
            Text(
              DateFormat("MMMM").format(e.date),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          );
        }
        if (e.date.weekNumber() != lastItemDate.weekNumber()) {
          children.add(
            Text(
              'Week ${e.date.weekNumber()}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          );
        }
      }
      int idx = 0;
      final data = e.text.split("#").map((e) {
        idx++;
        if (idx == 1) {
          return TextSpan(text: e);
        }
        return TextSpan(
          text: "#$e",
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
        );
      }).toList();

      children.add(
        Text.rich(
          TextSpan(
            text: "${DateFormat("yyyy-MM-dd").format(e.date)} :  ",
            children: data,
          ),
        ),
      );
      lastItemDate = e.date;
    }
    return children;
  }
}
