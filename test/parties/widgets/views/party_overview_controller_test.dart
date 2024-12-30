import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
import 'package:ceal_chronicler_f/io/chronicle_codec.dart';
import 'package:ceal_chronicler_f/io/file/file_adapter.dart';
import 'package:ceal_chronicler_f/io/file/file_processor.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection_repository.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/locations/model/location_sorter.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/parties/model/party.dart';
import 'package:ceal_chronicler_f/parties/model/party_repository.dart';
import 'package:ceal_chronicler_f/parties/widgets/view/party_overview_controller.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/file_adapter_mock.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late PartyRepository partyRepository;
  late PartyOverviewController controller;
  setUp(() {
    getIt.reset();
    pointInTimeRepository = PointInTimeRepository();
    partyRepository = PartyRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    getIt.registerSingleton<PartyRepository>(partyRepository);
    getIt.registerSingleton<LocationConnectionRepository>(
        LocationConnectionRepository());
    getIt.registerSingleton<IncidentRepository>(IncidentRepository());
    getIt.registerSingleton<CharacterRepository>(CharacterRepository());
    getIt.registerSingleton<LocationRepository>(LocationRepository());
    getIt.registerSingleton<ChronicleCodec>(ChronicleCodec());
    getIt.registerSingleton<KeyFieldResolver>(KeyFieldResolver());
    getIt.registerSingleton<LocationSorter>(LocationSorter());
    getIt.registerSingleton<FileAdapter>(FileAdapterMock());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<CommandProcessor>(CommandProcessor());
    getIt.registerSingleton<ViewProcessor>(ViewProcessor());
    getIt.registerSingleton<FileProcessor>(FileProcessor());
    controller = PartyOverviewController();
  });

  test(
    "Party should be displayed if active point in time is between first and last appearance",
    () {
      PointInTime activePointInTime = pointInTimeRepository.activePointInTime;
      var party = Party(activePointInTime.id);
      partyRepository.add(party);

      List<Party> parties = controller.entitiesAtActivePointInTime;

      expect(parties, contains(party));
    },
  );

  test(
    "Party should not be displayed if active point in time is before its first appearance",
    () {
      PointInTime activePointInTime = pointInTimeRepository.activePointInTime;
      var party = Party(activePointInTime.id);
      partyRepository.add(party);

      PointInTime pointBeforeFirstAppearance = PointInTime("Before");
      pointInTimeRepository.addAtIndex(0, pointBeforeFirstAppearance);
      pointInTimeRepository.activePointInTime = pointBeforeFirstAppearance;
      List<Party> parties = controller.entitiesAtActivePointInTime;

      expect(parties, isNot(contains(party)));
    },
  );

  test(
    "Party should not be displayed if active point in time is after its last appearance",
    () {
      PointInTime activePointInTime = pointInTimeRepository.activePointInTime;
      var party = Party(activePointInTime.id);
      party.lastAppearance = activePointInTime.id;
      partyRepository.add(party);

      PointInTime pointAfterLastAppearance = PointInTime("After");
      pointInTimeRepository.addAtIndex(1, pointAfterLastAppearance);
      pointInTimeRepository.activePointInTime = pointAfterLastAppearance;
      List<Party> parties = controller.entitiesAtActivePointInTime;

      expect(parties, isNot(contains(party)));
    },
  );
}
