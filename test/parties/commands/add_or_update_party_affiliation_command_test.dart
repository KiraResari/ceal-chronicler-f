import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/parties/commands/add_or_update_party_affiliation_command.dart';
import 'package:ceal_chronicler_f/parties/model/party.dart';
import 'package:ceal_chronicler_f/parties/model/party_id.dart';
import 'package:ceal_chronicler_f/parties/model/party_repository.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late CommandProcessor processor;
  late PartyRepository repository;
  late PointInTimeRepository pointInTimeRepository;
  late CharacterRepository characterRepository;
  late LocationRepository locationRepository;
  late KeyFieldResolver resolver;

  setUp(() {
    getIt.reset();
    repository = PartyRepository();
    getIt.registerSingleton<PartyRepository>(repository);
    pointInTimeRepository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    characterRepository = CharacterRepository();
    getIt.registerSingleton<CharacterRepository>(characterRepository);
    locationRepository = LocationRepository();
    getIt.registerSingleton<LocationRepository>(locationRepository);
    getIt.registerSingleton<ViewRepository>(ViewRepository());
    resolver = KeyFieldResolver();
    getIt.registerSingleton<KeyFieldResolver>(resolver);
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    processor = CommandProcessor();
  });

  test(
    "Processing command should add character to party",
    () {
      PointInTime presentPoint = pointInTimeRepository.activePointInTime;
      var character = Character(presentPoint.id);
      var party = Party(presentPoint.id);
      var command =
          AddOrUpdatePartyAffiliationCommand(character, party, presentPoint.id);

      processor.process(command);

      PartyId? partyId = resolver.getCurrentValue(character.party);
      expect(partyId, party.id);
    },
  );

  test(
    "Undoing command should remove character from party",
    () {
      PointInTime presentPoint = pointInTimeRepository.activePointInTime;
      var character = Character(presentPoint.id);
      var party = Party(presentPoint.id);
      var command =
          AddOrUpdatePartyAffiliationCommand(character, party, presentPoint.id);

      processor.process(command);
      processor.undo();

      PartyId? partyId = resolver.getCurrentValue(character.party);
      expect(partyId, isNull);
    },
  );

  test(
    "Redoing command should re-add character to party",
        () {
      PointInTime presentPoint = pointInTimeRepository.activePointInTime;
      var character = Character(presentPoint.id);
      var party = Party(presentPoint.id);
      var command =
      AddOrUpdatePartyAffiliationCommand(character, party, presentPoint.id);

      processor.process(command);
      processor.undo();
      processor.redo();

      PartyId? partyId = resolver.getCurrentValue(character.party);
      expect(partyId, party.id);
    },
  );
}
