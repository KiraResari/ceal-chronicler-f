import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/model/incident.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
import 'package:ceal_chronicler_f/io/file/file_adapter.dart';
import 'package:ceal_chronicler_f/io/file/file_service.dart';
import 'package:ceal_chronicler_f/io/repository_service.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/file_adapter_mock.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late IncidentRepository incidentRepository;
  late CharacterRepository characterRepository;
  late FileService fileService;

  setUp(() {
    getIt.reset();
    pointInTimeRepository = PointInTimeRepository();
    incidentRepository = IncidentRepository();
    characterRepository = CharacterRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    getIt.registerSingleton<IncidentRepository>(incidentRepository);
    getIt.registerSingleton<CharacterRepository>(characterRepository);
    getIt.registerSingleton<RepositoryService>(RepositoryService());
    getIt.registerSingleton<FileAdapter>(FileAdaptorMock());
    fileService = FileService();
    getIt.registerSingleton<FileService>(fileService);
  });

  test(
    "Saving and loading should preserve points in time",
    () async {
      PointInTime newPoint = pointInTimeRepository.createNewAtIndex(0);

      await fileService.save();
      pointInTimeRepository.remove(newPoint);
      await fileService.load();

      expect(pointInTimeRepository.pointsInTime, contains(newPoint));
    },
  );

  test(
    "Saving and loading should preserve incidents",
    () async {
      Incident incident = Incident();
      incidentRepository.add(incident);

      await fileService.save();
      incidentRepository.remove(incident);
      await fileService.load();

      expect(incidentRepository.content, contains(incident));
    },
  );

  test(
    "Saving and loading should preserve characters",
        () async {
      Character character = Character(PointInTimeId());
      characterRepository.add(character);

      await fileService.save();
      characterRepository.remove(character);
      await fileService.load();

      expect(characterRepository.content, contains(character));
    },
  );

  test(
    "After loading, a point in time of the loaded chronicle should be active",
    () async {
      await fileService.save();
      PointInTime originalPoint = pointInTimeRepository.first;

      PointInTime newPoint = pointInTimeRepository.createNewAtIndex(0);
      pointInTimeRepository.activePointInTime = newPoint;
      await fileService.load();

      expect(pointInTimeRepository.activePointInTime, equals(originalPoint));
    },
  );
}
