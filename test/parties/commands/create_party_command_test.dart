import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/parties/commands/create_party_command.dart';
import 'package:ceal_chronicler_f/parties/model/party.dart';
import 'package:ceal_chronicler_f/parties/model/party_repository.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CommandProcessor processor;
  late PartyRepository repository;

  setUp(() {
    getIt.reset();
    repository = PartyRepository();
    getIt.registerSingleton<PartyRepository>(repository);
    getIt.registerSingleton<PointInTimeRepository>(PointInTimeRepository());
    getIt.registerSingleton<ViewRepository>(ViewRepository());
    getIt.registerSingleton<KeyFieldResolver>(KeyFieldResolver());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    processor = CommandProcessor();
  });

  test(
    "Processing command should add new party",
    () {
      int initialCount = repository.content.length;
      var command = CreatePartyCommand(PointInTimeId());

      processor.process(command);

      expect(repository.content.length, equals(initialCount + 1));
    },
  );

  test(
    "Undoing command should remove new party",
    () {
      var command = CreatePartyCommand(PointInTimeId());

      processor.process(command);
      Party createdEntity = repository.content.first;
      processor.undo();

      expect(repository.content, isNot(contains(createdEntity)));
    },
  );

  test(
    "Redoing command should re-add new party",
    () {
      var command = CreatePartyCommand(PointInTimeId());

      processor.process(command);
      Party createdEntity = repository.content.first;
      processor.undo();
      processor.redo();

      expect(repository.content, contains(createdEntity));
    },
  );
}
