import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/incidents/model/incident.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';

import '../characters/model/character.dart';
import '../get_it_context.dart';
import '../incidents/model/incident_repository.dart';
import '../locations/model/location.dart';
import '../locations/model/location_connection.dart';
import '../locations/model/location_connection_repository.dart';
import '../timeline/model/point_in_time.dart';
import '../timeline/model/point_in_time_repository.dart';
import 'chronicle.dart';

class ChronicleCodec {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _incidentRepository = getIt.get<IncidentRepository>();
  final _characterRepository = getIt.get<CharacterRepository>();
  final _locationRepository = getIt.get<LocationRepository>();
  final _locationConnectionRepository =
      getIt.get<LocationConnectionRepository>();

  Chronicle assembleFromRepositories() {
    List<PointInTime> pointsInTime = _pointInTimeRepository.pointsInTime;
    List<Incident> incidents = _incidentRepository.content;
    List<Character> characters = _characterRepository.content;
    List<Location> locations = _locationRepository.content;
    List<LocationConnection> locationConnections =
        _locationConnectionRepository.content;
    return Chronicle(
      pointsInTime: pointsInTime,
      incidents: incidents,
      characters: characters,
      locations: locations,
      locationConnections: locationConnections,
    );
  }

  void distributeToRepositories(Chronicle chronicle) {
    _pointInTimeRepository.pointsInTime = chronicle.pointsInTime;
    _pointInTimeRepository.activePointInTime =
        _pointInTimeRepository.pointsInTime.first;
    _incidentRepository.content = chronicle.incidents;
    _characterRepository.content = chronicle.characters;
    _locationRepository.content = chronicle.locations;
    _locationConnectionRepository.content = chronicle.locationConnections;
  }
}
