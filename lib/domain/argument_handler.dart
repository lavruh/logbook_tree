import 'dart:io';

class ArgumentHandler {
  static final ArgumentHandler _instance = ArgumentHandler._internal();

  factory ArgumentHandler() {
    return _instance;
  }

  ArgumentHandler._internal() {
    _argsHandlers['dataSourceDir'] = (String val) {
      final dir = Directory(val);
      if (dir.existsSync()) {
        _args['dataSourceDir'] = dir;
      }
    };
  }

  final Map<String, dynamic> _args = {'dataSourceDir': null};
  final Map<String, void Function(String)> _argsHandlers = {};

  Directory? get dataSourceDir => _args['dataSourceDir'];

  void handleArgs(List<String> args) {
    if (args.isNotEmpty) {
      for (String arg in args) {
        for (String argName in _args.keys) {
          _handleArg(arg: arg, argName: argName);
        }
      }
    }
  }

  void _handleArg({required String arg, required String argName}) {
    if (arg.startsWith('--$argName=') || arg.startsWith('-$argName=')) {
      final equalSignIndex = arg.indexOf('=');
      final val = arg.substring(equalSignIndex + 1);
      if (equalSignIndex != -1 && equalSignIndex < arg.length - 1) {
        final fnk = _argsHandlers[argName];
        if (fnk != null) fnk(val);
      }
    }
  }
}
