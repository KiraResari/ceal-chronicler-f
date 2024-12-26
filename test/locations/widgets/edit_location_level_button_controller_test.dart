import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/model/location_level.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/locations/widgets/edit_location_level_button_controller.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter/src/material/dropdown_menu.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late PointInTimeRepository pointInTimeRepository;
  late LocationRepository locationRepository;

  setUp(() {
    getIt.reset();
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    pointInTimeRepository = PointInTimeRepository();
    getIt.registerSingleton<PointInTimeRepository>(pointInTimeRepository);
    locationRepository = LocationRepository();
    getIt.registerSingleton<LocationRepository>(locationRepository);
    getIt.registerSingleton<KeyFieldResolver>(KeyFieldResolver());
    getIt.registerSingleton<CommandProcessor>(CommandProcessor());
  });

  test(
    "validEntries should return valid location levels",
    () {
      var controller = EditLocationLevelButtonController();

      List<DropdownMenuEntry<LocationLevel>> validEntries =
          controller.validEntries;

      expect(
        validEntries.map((entry) => entry.value).toList(),
        containsAll(LocationLevel.values),
      );
    },
  );
}
