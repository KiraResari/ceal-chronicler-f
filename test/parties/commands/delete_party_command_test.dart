import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/parties/commands/delete_party_command.dart';
import 'package:ceal_chronicler_f/parties/model/party.dart';
import 'package:ceal_chronicler_f/parties/model/party_repository.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CommandProcessor processor;
  late KeyFieldResolver resolver;
  late PointInTimeRepository pointInTimeRepository;
  late PartyRepository partyRepository;

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<ViewRepository>(ViewRepository());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    pointInTimeRepository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    resolver = KeyFieldResolver();
    getIt.registerSingleton<KeyFieldResolver>(resolver);
    partyRepository = PartyRepository();
    getIt.registerSingleton<PartyRepository>(partyRepository);
    processor = CommandProcessor();
  });

  test(
    "Processing command should delete party",
    () {
      var party = Party(PointInTimeId());
      partyRepository.add(party);
      var command = DeletePartyCommand(party);

      processor.process(command);

      expect(partyRepository.content, isNot(contains(party)));
    },
  );

  test(
    "Undoing command should restore deleted party",
    () {
      var party = Party(PointInTimeId());
      partyRepository.add(party);
      var command = DeletePartyCommand(party);

      processor.process(command);
      processor.undo();

      expect(partyRepository.content, contains(party));
    },
  );

  test(
    "Undoing command should restore deleted party with correct name",
    () {
      var party = Party(PointInTimeId());
      party.name.addOrUpdateKeyAtTime(
          "Vaught", pointInTimeRepository.activePointInTime.id);
      partyRepository.add(party);
      var command = DeletePartyCommand(party);

      processor.process(command);
      processor.undo();

      var currentValue =
          resolver.getCurrentValue(partyRepository.content[0].name);
      expect(currentValue, equals("Vaught"));
    },
  );

  test(
    "Redoing command should re-delete party",
    () {
      var party = Party(PointInTimeId());
      partyRepository.add(party);
      var command = DeletePartyCommand(party);

      processor.process(command);
      processor.undo();
      processor.redo();

      expect(partyRepository.content, isNot(contains(party)));
    },
  );
}
