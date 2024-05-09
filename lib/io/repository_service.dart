import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/incidents/model/incident.dart';

import '../characters/model/character.dart';
import '../get_it_context.dart';
import '../incidents/model/incident_repository.dart';
import '../timeline/model/point_in_time.dart';
import '../timeline/model/point_in_time_repository.dart';
import 'chronicle.dart';

class RepositoryService {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _incidentRepository = getIt.get<IncidentRepository>();
  final _characterRepository = getIt.get<CharacterRepository>();

  Chronicle assembleChronicle() {
    List<PointInTime> pointsInTime = _pointInTimeRepository.pointsInTime;
    List<Incident> incidents = _incidentRepository.content;
    List<Character> characters = _characterRepository.content;
    return Chronicle(
      pointsInTime: pointsInTime,
      incidents: incidents,
      characters: characters,
    );
  }

  void distributeChronicle(Chronicle chronicle) {
    _pointInTimeRepository.pointsInTime = chronicle.pointsInTime;
    _pointInTimeRepository.activePointInTime =
        _pointInTimeRepository.pointsInTime.first;
    _incidentRepository.content = chronicle.incidents;
    _characterRepository.content = chronicle.characters;
  }
}
