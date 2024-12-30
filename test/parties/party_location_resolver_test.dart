import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/model/location_id.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/parties/model/party.dart';
import 'package:ceal_chronicler_f/parties/model/party_repository.dart';
import 'package:ceal_chronicler_f/parties/party_location_resolver.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late PartyRepository partyRepository;
  late CharacterRepository characterRepository;
  late PartyLocationResolver partyLocationResolver;

  setUp(() {
    getIt.reset();
    pointInTimeRepository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    getIt.registerSingleton<KeyFieldResolver>(KeyFieldResolver());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    getIt.registerSingleton<CommandProcessor>(CommandProcessor());
    getIt.registerSingleton<ViewProcessor>(ViewProcessor());
    partyRepository = PartyRepository();
    getIt.registerSingleton<PartyRepository>(partyRepository);
    characterRepository = CharacterRepository();
    getIt.registerSingleton<CharacterRepository>(characterRepository);
    partyLocationResolver = PartyLocationResolver();
  });

  test(
    "getLocationMapOfParty should correctly amalgamate location map",
    () {
      PointInTime firstPointInTime = pointInTimeRepository.activePointInTime;
      var secondPointInTime = PointInTime("Second Point In Time");
      var thirdPointInTime = PointInTime("Third Point In Time");
      pointInTimeRepository.addAtIndex(1, secondPointInTime);
      pointInTimeRepository.addAtIndex(2, thirdPointInTime);
      var firstLocationId = LocationId();
      var secondLocationId = LocationId();
      var thirdLocationId = LocationId();
      var party = Party(firstPointInTime.id);
      var firstCharacter = Character(firstPointInTime.id);
      firstCharacter.party.addOrUpdateKeyAtTime(party.id, firstPointInTime.id);
      firstCharacter.party.addOrUpdateKeyAtTime(null, thirdPointInTime.id);
      firstCharacter.presentLocation
          .addOrUpdateKeyAtTime(firstLocationId, firstPointInTime.id);
      firstCharacter.presentLocation
          .addOrUpdateKeyAtTime(secondLocationId, secondPointInTime.id);
      firstCharacter.presentLocation
          .addOrUpdateKeyAtTime(firstLocationId, thirdPointInTime.id);
      var secondCharacter = Character(secondPointInTime.id);
      secondCharacter.party.addOrUpdateKeyAtTime(party.id, thirdPointInTime.id);
      secondCharacter.presentLocation
          .addOrUpdateKeyAtTime(thirdLocationId, thirdPointInTime.id);
      characterRepository.add(firstCharacter);
      characterRepository.add(secondCharacter);

      Map<PointInTimeId, LocationId?> partyLocationMap =
          partyLocationResolver.getLocationMapOfParty(party.id);

      expect(
          partyLocationMap,
          equals({
            firstPointInTime.id: firstLocationId,
            secondPointInTime.id: secondLocationId,
            thirdPointInTime.id: thirdLocationId,
          }));
    },
  );
}
