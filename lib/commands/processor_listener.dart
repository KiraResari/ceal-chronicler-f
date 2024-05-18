import 'package:flutter/material.dart';

import '../get_it_context.dart';
import '../io/file/file_processor.dart';
import '../view/view_processor.dart';
import 'command_processor.dart';

abstract class ProcessorListener extends ChangeNotifier {
  final commandProcessor = getIt.get<CommandProcessor>();
  final viewProcessor = getIt.get<ViewProcessor>();
  final fileProcessor = getIt.get<FileProcessor>();

  ProcessorListener() {
    commandProcessor.addListener(notifyListenersCall);
    viewProcessor.addListener(notifyListenersCall);
    fileProcessor.addListener(notifyListenersCall);
  }

  void notifyListenersCall() => notifyListeners();

  @override
  void dispose() {
    super.dispose();
    commandProcessor.removeListener(notifyListenersCall);
    viewProcessor.removeListener(notifyListenersCall);
    fileProcessor.removeListener(notifyListenersCall);
  }
}
