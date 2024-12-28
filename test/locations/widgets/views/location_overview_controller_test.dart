import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/incidents/model/incident_repository.dart';
import 'package:ceal_chronicler_f/io/chronicle_codec.dart';
import 'package:ceal_chronicler_f/io/file/file_adapter.dart';
import 'package:ceal_chronicler_f/io/file/file_processor.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_connection_repository.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/locations/model/location_sorter.dart';
import 'package:ceal_chronicler_f/locations/widgets/views/location_overview_controller.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/file_adapter_mock.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late LocationRepository locationRepository;
  late LocationOverviewController controller;
  setUp(() {
    getIt.reset();
    pointInTimeRepository = PointInTimeRepository();
    locationRepository = LocationRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    getIt.registerSingleton<LocationRepository>(locationRepository);
    getIt.registerSingleton<LocationConnectionRepository>(
        LocationConnectionRepository());
    getIt.registerSingleton<IncidentRepository>(IncidentRepository());
    getIt.registerSingleton<CharacterRepository>(CharacterRepository());
    getIt.registerSingleton<ChronicleCodec>(ChronicleCodec());
    getIt.registerSingleton<KeyFieldResolver>(KeyFieldResolver());
    getIt.registerSingleton<LocationSorter>(LocationSorter());
    getIt.registerSingleton<FileAdapter>(FileAdapterMock());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<CommandProcessor>(CommandProcessor());
    getIt.registerSingleton<ViewProcessor>(ViewProcessor());
    getIt.registerSingleton<FileProcessor>(FileProcessor());
    controller = LocationOverviewController();
  });

  test(
    "Character should be displayed if active point in time is between first and last appearance",
    () {
      PointInTime activePointInTime = pointInTimeRepository.activePointInTime;
      var location = Location(activePointInTime.id);
      locationRepository.add(location);

      List<Location> locations = controller.entitiesAtActivePointInTime;

      expect(locations, contains(location));
    },
  );

  test(
    "Character should not be displayed if active point in time is before its first appearance",
    () {
      PointInTime activePointInTime = pointInTimeRepository.activePointInTime;
      var location = Location(activePointInTime.id);
      locationRepository.add(location);

      PointInTime pointBeforeCharacterFirstAppearance = PointInTime("Before");
      pointInTimeRepository.addAtIndex(0, pointBeforeCharacterFirstAppearance);
      pointInTimeRepository.activePointInTime =
          pointBeforeCharacterFirstAppearance;
      List<Location> locations = controller.entitiesAtActivePointInTime;

      expect(locations, isNot(contains(location)));
    },
  );

  test(
    "Character should not be displayed if active point in time is after its last appearance",
    () {
      PointInTime activePointInTime = pointInTimeRepository.activePointInTime;
      var location = Location(activePointInTime.id);
      location.lastAppearance = activePointInTime.id;
      locationRepository.add(location);

      PointInTime pointAfterCharacterLastAppearance = PointInTime("After");
      pointInTimeRepository.addAtIndex(1, pointAfterCharacterLastAppearance);
      pointInTimeRepository.activePointInTime =
          pointAfterCharacterLastAppearance;
      List<Location> locations = controller.entitiesAtActivePointInTime;

      expect(locations, isNot(contains(location)));
    },
  );
}
