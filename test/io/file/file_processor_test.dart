import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/model/incident.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
import 'package:ceal_chronicler_f/io/file/file_adapter.dart';
import 'package:ceal_chronicler_f/io/file/file_processor.dart';
import 'package:ceal_chronicler_f/io/chronicle_codec.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection_repository.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/commands/create_point_in_time_command.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/file_adapter_mock.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late IncidentRepository incidentRepository;
  late CharacterRepository characterRepository;
  late LocationRepository locationRepository;
  late FileProcessor fileProcessor;
  late CommandProcessor commandProcessor;

  setUp(() {
    getIt.reset();
    pointInTimeRepository = PointInTimeRepository();
    incidentRepository = IncidentRepository();
    characterRepository = CharacterRepository();
    locationRepository = LocationRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    getIt.registerSingleton<IncidentRepository>(incidentRepository);
    getIt.registerSingleton<CharacterRepository>(characterRepository);
    getIt.registerSingleton<LocationRepository>(locationRepository);
    getIt.registerSingleton<LocationConnectionRepository>(
        LocationConnectionRepository());
    getIt.registerSingleton<ChronicleCodec>(ChronicleCodec());
    getIt.registerSingleton<FileAdapter>(FileAdapterMock());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    fileProcessor = FileProcessor();
    commandProcessor= CommandProcessor();
  });

  test(
    "Saving and loading should preserve points in time",
    () async {
      PointInTime newPoint = pointInTimeRepository.createNewAtIndex(0);

      await fileProcessor.save();
      pointInTimeRepository.remove(newPoint);
      await fileProcessor.load();

      expect(pointInTimeRepository.pointsInTime, contains(newPoint));
    },
  );

  test(
    "Saving and loading should preserve incidents",
    () async {
      Incident incident = Incident();
      incidentRepository.add(incident);

      await fileProcessor.save();
      incidentRepository.remove(incident);
      await fileProcessor.load();

      expect(incidentRepository.content, contains(incident));
    },
  );

  test(
    "Saving and loading should preserve characters",
        () async {
      Character character = Character(PointInTimeId());
      characterRepository.add(character);

      await fileProcessor.save();
      characterRepository.remove(character);
      await fileProcessor.load();

      expect(characterRepository.content, contains(character));
    },
  );

  test(
    "Saving and loading should preserve locations",
        () async {
      var location = Location(PointInTimeId());
      locationRepository.add(location);

      await fileProcessor.save();
      locationRepository.remove(location);
      await fileProcessor.load();

      expect(locationRepository.content, contains(location));
    },
  );

  test(
    "After loading, a point in time of the loaded chronicle should be active",
    () async {
      await fileProcessor.save();
      PointInTime originalPoint = pointInTimeRepository.first;

      PointInTime newPoint = pointInTimeRepository.createNewAtIndex(0);
      pointInTimeRepository.activePointInTime = newPoint;
      await fileProcessor.load();

      expect(pointInTimeRepository.activePointInTime, equals(originalPoint));
    },
  );

  test(
    "Saving should not be necessary when no commands have been executed",
        () {
      expect(fileProcessor.isSavingNecessary, isFalse);
    },
  );

  test(
    "Saving should be necessary if a command has been executed but not saved",
        () {
      var command = CreatePointInTimeCommand(0);

      commandProcessor.process(command);

      expect(fileProcessor.isSavingNecessary, isTrue);
    },
  );

  test(
    "Saving should not be necessary if a command has been executed and saved",
        () async {
      var command = CreatePointInTimeCommand(0);

      commandProcessor.process(command);
      await fileProcessor.save();

      expect(fileProcessor.isSavingNecessary, isFalse);
    },
  );

  test(
    "Saving should not be necessary if a command has been executed and undone",
        () async {
      var command = CreatePointInTimeCommand(0);

      commandProcessor.process(command);
      commandProcessor.undo();

      expect(fileProcessor.isSavingNecessary, isFalse);
    },
  );

  test(
    "Saving should be necessary if a command has been executed, saved and undone",
        () async {
      var command = CreatePointInTimeCommand(0);

      commandProcessor.process(command);
      await fileProcessor.save();
      commandProcessor.undo();

      expect(fileProcessor.isSavingNecessary, isTrue);
    },
  );

  test(
    "Saving should not be necessary if a command has been executed, saved, undone and redone",
        () async {
      var command = CreatePointInTimeCommand(0);

      commandProcessor.process(command);
      await fileProcessor.save();
      commandProcessor.undo();
      commandProcessor.redo();

      expect(fileProcessor.isSavingNecessary, isFalse);
    },
  );

  test(
    "Saving should be necessary if a command has been executed, saved, undone and then another command executed",
        () async {
      var command = CreatePointInTimeCommand(0);

      commandProcessor.process(command);
      await fileProcessor.save();
      commandProcessor.undo();
      commandProcessor.process(command);

      expect(fileProcessor.isSavingNecessary, isTrue);
    },
  );

  test(
    "Saving should not be necessary after loading",
        () async {
      var command = CreatePointInTimeCommand(0);

      commandProcessor.process(command);
      await fileProcessor.save();
      commandProcessor.process(command);
      await fileProcessor.load();

      expect(fileProcessor.isSavingNecessary, isFalse);
    },
  );

  test(
    "Undo should not be possible after loading",
        () async {
      var command = CreatePointInTimeCommand(0);

      commandProcessor.process(command);
      await fileProcessor.save();
      commandProcessor.process(command);
      await fileProcessor.load();

      expect(commandProcessor.isUndoPossible, isFalse);
    },
  );

  test(
    "Redo should not be possible after loading",
        () async {
      var command = CreatePointInTimeCommand(0);

      commandProcessor.process(command);
      await fileProcessor.save();
      commandProcessor.process(command);
      await fileProcessor.load();

      expect(commandProcessor.isRedoPossible, isFalse);
    },
  );
}
