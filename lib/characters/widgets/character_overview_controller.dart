import 'package:ceal_chronicler_f/exceptions/point_in_time_not_found_exception.dart';
import 'package:flutter/material.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../../view/view_processor.dart';
import '../model/character.dart';
import '../model/character_repository.dart';

class CharacterOverviewController extends ChangeNotifier {
  final _commandProcessor = getIt.get<CommandProcessor>();
  final _characterRepository = getIt.get<CharacterRepository>();
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _viewProcessor = getIt.get<ViewProcessor>();

  CharacterOverviewController() {
    _pointInTimeRepository.addListener(_notifyListenersCall);
    _commandProcessor.addListener(_notifyListenersCall);
    _viewProcessor.addListener(() => notifyListeners());
  }

  void _notifyListenersCall() => notifyListeners();

  List<Character> get charactersAtActivePointInTime {
    List<Character> allCharacters = _characterRepository.content;
    List<Character> extantCharacters = [];
    for (Character character in allCharacters) {
      if (_characterExistsAtCurrentPointInTime(character)) {
        extantCharacters.add(character);
      }
    }
    return extantCharacters;
  }

  bool _characterExistsAtCurrentPointInTime(Character character) {
    try {
      return _pointInTimeRepository
          .activePointInTimeIsNotBefore(character.firstAppearance);
    } on PointInTimeNotFoundException catch (_) {
      return false;
    }
  }
}
