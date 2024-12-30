import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/parties/commands/add_or_update_party_affiliation_command.dart';
import 'package:ceal_chronicler_f/parties/model/party.dart';
import 'package:ceal_chronicler_f/parties/model/party_id.dart';
import 'package:ceal_chronicler_f/parties/model/party_repository.dart';
import 'package:ceal_chronicler_f/parties/party_location_resolver.dart';
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
    getIt.registerSingleton<PartyLocationResolver>(PartyLocationResolver());
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

  test(
    "Adding a character to a party that already has a character should overwrite the added character's location keys with those contained in the party",
    () {
      PointInTime prologue = pointInTimeRepository.activePointInTime;
      PointInTime chapterOne = pointInTimeRepository.createNewAtIndex(1);
      PointInTime chapterTwo = pointInTimeRepository.createNewAtIndex(2);
      PointInTime chapterThree = pointInTimeRepository.createNewAtIndex(3);
      Location aidenous = createAndAddLocation(prologue, locationRepository);
      Location vaught = createAndAddLocation(prologue, locationRepository);
      Location fienyn = createAndAddLocation(prologue, locationRepository);
      Location kiehlero = createAndAddLocation(prologue, locationRepository);
      Character sylvia = createAndAddCharacter(chapterOne, characterRepository);
      Character bokay = createAndAddCharacter(prologue, characterRepository);
      sylvia.presentLocation.addOrUpdateKeyAtTime(aidenous.id, chapterOne.id);
      sylvia.presentLocation.addOrUpdateKeyAtTime(vaught.id, chapterThree.id);
      bokay.presentLocation.addOrUpdateKeyAtTime(fienyn.id, prologue.id);
      bokay.presentLocation.addOrUpdateKeyAtTime(kiehlero.id, chapterTwo.id);
      var party = Party(prologue.id);
      sylvia.party.addOrUpdateKeyAtTime(party.id, chapterOne.id);
      var command =
          AddOrUpdatePartyAffiliationCommand(bokay, party, chapterThree.id);

      processor.process(command);

      expect(
          bokay.presentLocation.keys,
          equals({
            prologue.id: fienyn.id,
            chapterTwo.id: kiehlero.id,
            chapterThree.id: vaught.id
          }));
    },
  );

  test(
    "Undoing adding of character to a party that already has a character should restore character's original location keys",
        () {
      PointInTime prologue = pointInTimeRepository.activePointInTime;
      PointInTime chapterOne = pointInTimeRepository.createNewAtIndex(1);
      PointInTime chapterTwo = pointInTimeRepository.createNewAtIndex(2);
      PointInTime chapterThree = pointInTimeRepository.createNewAtIndex(3);
      Location aidenous = createAndAddLocation(prologue, locationRepository);
      Location vaught = createAndAddLocation(prologue, locationRepository);
      Location fienyn = createAndAddLocation(prologue, locationRepository);
      Location kiehlero = createAndAddLocation(prologue, locationRepository);
      Character sylvia = createAndAddCharacter(chapterOne, characterRepository);
      Character bokay = createAndAddCharacter(prologue, characterRepository);
      sylvia.presentLocation.addOrUpdateKeyAtTime(aidenous.id, chapterOne.id);
      sylvia.presentLocation.addOrUpdateKeyAtTime(vaught.id, chapterThree.id);
      bokay.presentLocation.addOrUpdateKeyAtTime(fienyn.id, prologue.id);
      bokay.presentLocation.addOrUpdateKeyAtTime(kiehlero.id, chapterTwo.id);
      var party = Party(prologue.id);
      sylvia.party.addOrUpdateKeyAtTime(party.id, chapterOne.id);
      var command =
      AddOrUpdatePartyAffiliationCommand(bokay, party, chapterThree.id);

      processor.process(command);
      processor.undo();

      expect(
          bokay.presentLocation.keys,
          equals({
            prologue.id: fienyn.id,
            chapterTwo.id: kiehlero.id
          }));
    },
  );
}

Location createAndAddLocation(
  PointInTime point,
  LocationRepository locationRepository,
) {
  var location = Location(point.id);
  locationRepository.add(location);
  return location;
}

Character createAndAddCharacter(
  PointInTime point,
  CharacterRepository characterRepository,
) {
  var character = Character(point.id);
  characterRepository.add(character);
  return character;
}
