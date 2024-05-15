import 'package:flutter/material.dart';

import '../get_it_context.dart';
import '../view/view_processor.dart';
import 'command_processor.dart';

abstract class ProcessorListener extends ChangeNotifier {
  final commandProcessor = getIt.get<CommandProcessor>();
  final _viewProcessor = getIt.get<ViewProcessor>();

  ProcessorListener() {
    commandProcessor.addListener(notifyListenersCall);
    _viewProcessor.addListener(notifyListenersCall);
  }

  void notifyListenersCall() => notifyListeners();

  @override
  void dispose() {
    super.dispose();
    commandProcessor.removeListener(notifyListenersCall);
    _viewProcessor.removeListener(notifyListenersCall);
  }
}
