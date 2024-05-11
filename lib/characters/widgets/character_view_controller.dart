import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../../timeline/model/point_in_time.dart';
import '../../view/view_processor.dart';
import '../model/character.dart';
import '../model/character_id.dart';

class CharacterViewController extends ChangeNotifier {
  final Character? character;

  final _commandProcessor = getIt.get<CommandProcessor>();
  final _viewProcessor = getIt.get<ViewProcessor>();
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();

  CharacterViewController(CharacterId id)
      : character = getIt<CharacterRepository>().getContentElementById(id) {
    _commandProcessor.addListener(_notifyListenersCall);
    _viewProcessor.addListener(_notifyListenersCall);
  }

  void _notifyListenersCall() => notifyListeners();

  bool get characterFound => character != null;

  String get name => character != null ? character!.name : "Unknown";

  String get firstApperance {
    if (character != null) {
      PointInTime? point =
          _pointInTimeRepository.get(character!.firstAppearance);
      if (point != null) {
        return point.name;
      }
    }
    return "Unknown";
  }
}
