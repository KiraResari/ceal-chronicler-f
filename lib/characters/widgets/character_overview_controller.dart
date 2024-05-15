import '../../commands/processor_listener.dart';
import '../../exceptions/point_in_time_not_found_exception.dart';
import '../../get_it_context.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../model/character.dart';
import '../model/character_repository.dart';

class CharacterOverviewController extends ProcessorListener {
  final _characterRepository = getIt.get<CharacterRepository>();
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();

  CharacterOverviewController() : super() {
    _pointInTimeRepository.addListener(notifyListenersCall);
  }

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

  @override
  void dispose() {
    super.dispose();
    _pointInTimeRepository.removeListener(notifyListenersCall);
  }
}
