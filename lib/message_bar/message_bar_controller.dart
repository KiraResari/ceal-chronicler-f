import 'package:flutter/cupertino.dart';

import '../commands/command_processor.dart';
import '../get_it_context.dart';

class MessageBarController extends ChangeNotifier {
  final _commandProcessor = getIt.get<CommandProcessor>();

  MessageBarController() {
    _commandProcessor.addListener(() => notifyListeners());
  }

  String get message => _commandProcessor.statusMessage;
}
