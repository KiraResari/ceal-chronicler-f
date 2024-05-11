import 'package:flutter/material.dart';

import '../commands/command_processor.dart';
import '../get_it_context.dart';
import '../view/view_processor.dart';
import '../view/view_repository.dart';
import 'main_view_candidate.dart';

class MainViewController extends ChangeNotifier {
  final _commandProcessor = getIt.get<CommandProcessor>();
  final _viewProcessor = getIt.get<ViewProcessor>();
  final _viewRepository = getIt.get<ViewRepository>();


  MainViewController() {
    _commandProcessor.addListener(_notifyListenersCall);
    _viewProcessor.addListener(_notifyListenersCall);
  }
  void _notifyListenersCall() => notifyListeners();

  MainViewCandidate get activeView => _viewRepository.mainView;

}
