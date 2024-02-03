import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
import 'package:ceal_chronicler_f/io/file/file_service.dart';
import 'package:ceal_chronicler_f/io/repository_service.dart';
import 'package:ceal_chronicler_f/timeline/commands/create_point_in_time_command.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/file_service_mock.dart';

main() {
  late CommandProcessor processor;

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<PointInTimeRepository>(PointInTimeRepository());
    getIt.registerSingleton<IncidentRepository>(IncidentRepository());
    getIt.registerSingleton<RepositoryService>(RepositoryService());
    getIt.registerSingleton<FileService>(FileServiceMock());
    processor = CommandProcessor();
  });

  test(
    "Saving should not be necessary when no commands have been executed",
    () {
      expect(processor.isSavingNecessary, isFalse);
    },
  );

  test(
    "Saving should be necessary if a command has been executed but not saved",
    () {
      var command = CreatePointInTimeCommand(0);

      processor.process(command);

      expect(processor.isSavingNecessary, isTrue);
    },
  );

  test(
    "Saving should not be necessary if a command has been executed and saved",
    () async {
      var command = CreatePointInTimeCommand(0);

      processor.process(command);
      await processor.save();

      expect(processor.isSavingNecessary, isFalse);
    },
  );

  test(
    "Saving should not be necessary if a command has been executed and undone",
    () async {
      var command = CreatePointInTimeCommand(0);

      processor.process(command);
      processor.undo();

      expect(processor.isSavingNecessary, isFalse);
    },
  );

  test(
    "Saving should be necessary if a command has been executed, saved and undone",
    () async {
      var command = CreatePointInTimeCommand(0);

      processor.process(command);
      await processor.save();
      processor.undo();

      expect(processor.isSavingNecessary, isTrue);
    },
  );

  test(
    "Saving should not be necessary if a command has been executed, saved, undone and redone",
    () async {
      var command = CreatePointInTimeCommand(0);

      processor.process(command);
      await processor.save();
      processor.undo();
      processor.redo();

      expect(processor.isSavingNecessary, isFalse);
    },
  );

  test(
    "Saving should be necessary if a command has been executed, saved, undone and then another command executed",
        () async {
      var command = CreatePointInTimeCommand(0);

      processor.process(command);
      await processor.save();
      processor.undo();
      processor.process(command);

      expect(processor.isSavingNecessary, isTrue);
    },
  );

  test(
    "Saving should not be necessary after loading",
        () async {
      var command = CreatePointInTimeCommand(0);

      processor.process(command);
      await processor.save();
      processor.process(command);
      await processor.load();

      expect(processor.isSavingNecessary, isFalse);
    },
  );

  test(
    "Undo should not be possible after loading",
        () async {
      var command = CreatePointInTimeCommand(0);

      processor.process(command);
      await processor.save();
      processor.process(command);
      await processor.load();

      expect(processor.isUndoPossible, isFalse);
    },
  );

  test(
    "Redo should not be possible after loading",
        () async {
      var command = CreatePointInTimeCommand(0);

      processor.process(command);
      await processor.save();
      processor.process(command);
      await processor.load();

      expect(processor.isRedoPossible, isFalse);
    },
  );
}
