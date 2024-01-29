import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';

class CharacterOverviewController extends ChangeNotifier{

  final _commandProcessor = getIt.get<CommandProcessor>();


  CharacterOverviewController() {
    _commandProcessor.addListener(() => notifyListeners());
  }
}