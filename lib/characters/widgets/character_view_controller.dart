import '../../commands/processor_listener.dart';
import '../../get_it_context.dart';
import '../../timeline/model/point_in_time.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../model/character.dart';
import '../model/character_id.dart';
import '../model/character_repository.dart';

class CharacterViewController extends ProcessorListener {
  final Character? character;

  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();

  CharacterViewController(CharacterId id)
      : character = getIt<CharacterRepository>().getContentElementById(id),
        super() {
    _pointInTimeRepository.addListener(notifyListenersCall);
  }

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

  @override
  void dispose() {
    super.dispose();
    _pointInTimeRepository.removeListener(notifyListenersCall);
  }
}
