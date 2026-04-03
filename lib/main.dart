import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logbook_tree/domain/app_dir_provider.dart';
import 'package:logbook_tree/domain/argument_handler.dart';
import 'package:logbook_tree/ui/settings_screen.dart';
import 'ui/logbook_screen_desktop.dart';

void main(List<String> args) {
  final arguments = ArgumentHandler();
  arguments.handleArgs(args);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logbook App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Consumer(
        builder: (context, ref, _) {
          final appPath = ref.watch(appDirProvider);
          return appPath.when(
            data: (value) => const LogbookScreenDesktop(),
            error: (e, stack) => const SettingsScreen(),
            loading: () =>
                Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        },
      ),
    );
  }
}
