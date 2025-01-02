import 'package:ceal_chronicler_f/characters/model/character.dart';
import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/io/file/file_processor.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/locations/model/location_sorter.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/parties/model/party.dart';
import 'package:ceal_chronicler_f/parties/model/party_id.dart';
import 'package:ceal_chronicler_f/parties/model/party_repository.dart';
import 'package:ceal_chronicler_f/parties/widgets/panels/party_id_key_field_panel_controller.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter/src/material/dropdown_menu.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/file_service_mock_lite.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late CharacterRepository characterRepository;
  late PartyRepository partyRepository;
  late KeyFieldResolver keyFieldResolver;

  setUp(() {
    getIt.reset();
    pointInTimeRepository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    keyFieldResolver = KeyFieldResolver();
    getIt.registerSingleton<KeyFieldResolver>(keyFieldResolver);
    getIt.registerSingleton<LocationSorter>(LocationSorter());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    getIt.registerSingleton<FileProcessor>(FileProcessorMockLite());
    getIt.registerSingleton<CommandProcessor>(CommandProcessor());
    getIt.registerSingleton<ViewProcessor>(ViewProcessor());
    characterRepository = CharacterRepository();
    partyRepository = PartyRepository();
    getIt.registerSingleton<CharacterRepository>(characterRepository);
    getIt.registerSingleton<PartyRepository>(partyRepository);
    getIt.registerSingleton<LocationRepository>(LocationRepository());

  });

  test(
    "validPartyEntries should return all valid parties plus none",
    () {
      PointInTimeId presentPointId = pointInTimeRepository.activePointInTime.id;
      var character = Character(presentPointId);
      var party = Party(presentPointId);
      partyRepository.add(party);
      var controller = PartyIdKeyFieldPanelController(character, character.party);

      List<DropdownMenuEntry<PartyId>> partyEntries =
          controller.validPartyEntries;

      expect(partyEntries.any((entry) => entry.value == party.id), isTrue);
      expect(
          partyEntries.any(
              (entry) => entry == PartyIdKeyFieldPanelController.noneEntry),
          isTrue);
    },
  );

  test(
    "validPartyEntries should not return parties with a firstAppearance after the current point in time",
    () {
      PointInTimeId presentPointId = pointInTimeRepository.activePointInTime.id;
      var futurePoint = PointInTime("Future Point In Time");
      pointInTimeRepository.addAtIndex(1, futurePoint);
      var character = Character(presentPointId);
      var party = Party(futurePoint.id);
      partyRepository.add(party);
      var controller = PartyIdKeyFieldPanelController(character, character.party);

      List<DropdownMenuEntry<PartyId>> partyEntries =
          controller.validPartyEntries;

      expect(partyEntries.any((entry) => entry.value == party.id), isFalse);
    },
  );

  test(
    "validPartyEntries should not return parties with a lastAppearance before the current point in time",
    () {
      PointInTimeId presentPointId = pointInTimeRepository.activePointInTime.id;
      var pastPoint = PointInTime("Past Point In Time");
      pointInTimeRepository.addAtIndex(0, pastPoint);
      var character = Character(presentPointId);
      var party = Party(pastPoint.id);
      party.lastAppearance = pastPoint.id;
      partyRepository.add(party);
      var controller = PartyIdKeyFieldPanelController(character, character.party);

      List<DropdownMenuEntry<PartyId>> partyEntries =
          controller.validPartyEntries;

      expect(partyEntries.any((entry) => entry.value == party.id), isFalse);
    },
  );

  test(
    "updateParty should correctly update character's present party",
    () {
      PointInTimeId presentPointId = pointInTimeRepository.activePointInTime.id;
      var character = Character(presentPointId);
      var controller = PartyIdKeyFieldPanelController(character, character.party);
      var newParty = Party(presentPointId);
      partyRepository.add(newParty);

      controller.updateKey(newParty.id);

      Party? presentParty = controller.presentParty;
      expect(presentParty, equals(newParty));
    },
  );

  test(
    "updateParty with nonePartyId should remove character's present party",
    () {
      PointInTimeId presentPointId = pointInTimeRepository.activePointInTime.id;
      var character = Character(presentPointId);
      var partyId = PartyId();
      character.party.addOrUpdateKeyAtTime(partyId, presentPointId);
      var controller = PartyIdKeyFieldPanelController(character, character.party);

      controller.updateKey(PartyIdKeyFieldPanelController.nonePartyId);

      PartyId? presentPartyId =
          keyFieldResolver.getCurrentValue(character.party);
      expect(presentPartyId, isNull);
    },
  );

  test(
    "updateParty with unknownLocationId should set character's present party to none, even if a previous key exists",
    () {
      var pastPoint = PointInTime("Past Point In Time");
      pointInTimeRepository.addAtIndex(0, pastPoint);
      var character = Character(pastPoint.id);
      var partyId = PartyId();
      character.party.addOrUpdateKeyAtTime(partyId, pastPoint.id);
      var controller = PartyIdKeyFieldPanelController(character, character.party);

      controller.updateKey(PartyIdKeyFieldPanelController.nonePartyId);

      PartyId? presentPartyId =
          keyFieldResolver.getCurrentValue(character.party);
      expect(presentPartyId, isNull);
    },
  );
}
