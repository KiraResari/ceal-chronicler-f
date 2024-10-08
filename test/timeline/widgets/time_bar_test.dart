import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/command_history.dart';
import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/io/file/file_processor.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/timeline/widgets/time_bar.dart';
import 'package:ceal_chronicler_f/timeline/widgets/time_bar_panel.dart';
import 'package:ceal_chronicler_f/utils/string_key.dart';
import 'package:ceal_chronicler_f/view/view_processor.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/file_service_mock_lite.dart';

void main() {
  setUp(() {
    getIt.reset();
    getIt.registerSingleton<CommandHistory>(CommandHistory());
    getIt.registerSingleton<MessageBarState>(MessageBarState());
    getIt.registerSingleton<PointInTimeRepository>(PointInTimeRepository());
    getIt.registerSingleton<CharacterRepository>(CharacterRepository());
    getIt.registerSingleton<ViewRepository>(ViewRepository());
    getIt.registerSingleton<CommandProcessor>(CommandProcessor());
    getIt.registerSingleton<ViewProcessor>(ViewProcessor());
    getIt.registerSingleton<FileProcessor>(FileProcessorMockLite());
    getIt.registerSingleton<KeyFieldResolver>(KeyFieldResolver());
  });

  testWidgets(
    'Time bar should start with one point in time',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TimeBar()));

      expect(find.byType(TimeBarPanel), findsOne);
    },
  );

  testWidgets(
    'First point in time should have delete button',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TimeBar()));

      expect(find.byKey(buildDeleteButtonKey(0)), findsOne);
    },
  );

  testWidgets(
    'Delete button of only point in time should be disabled',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TimeBar()));

      FloatingActionButton button = findDeleteButton(tester, 0);
      expect(button.onPressed, isNull);
    },
  );

  testWidgets(
    'Adding new point in time should work',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TimeBar()));

      await tapAddButton(tester, 0);

      expect(find.byType(TimeBarPanel), findsExactly(2));
    },
  );

  testWidgets(
    'Delete button of new point in time should be enabled',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TimeBar()));

      await tapAddButton(tester, 0);

      FloatingActionButton button = findDeleteButton(tester, 1);
      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets(
    'Delete button of first point in time should be enabled after new point is added',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TimeBar()));

      await tapAddButton(tester, 0);

      FloatingActionButton button = findDeleteButton(tester, 0);
      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets(
    'Initial point in time should be active',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TimeBar()));

      FloatingActionButton button = findPointInTimeButton(tester, 0);
      expect(button.onPressed, isNull);
    },
  );

  testWidgets(
    'New point in time should be inactive',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TimeBar()));

      await tapAddButton(tester, 0);

      FloatingActionButton button = findPointInTimeButton(tester, 1);
      expect(button.onPressed, isNull);
    },
  );

  testWidgets(
    'Deleting point in time should work once there are at least two',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TimeBar()));
      await tapAddButton(tester, 0);

      await tapDeleteButton(tester, 0);

      expect(find.byType(TimeBarPanel), findsOne);
    },
  );

  testWidgets(
    'Deleting first point in time should leave second point in time',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TimeBar()));
      await tapAddButton(tester, 0);

      await tapDeleteButton(tester, 0);

      expect(find.byKey(buildPointInTimeButtonKey(0)), findsOne);
    },
  );

  testWidgets(
    'Deleting first point in time should make remaining point in time active',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TimeBar()));
      await tapAddButton(tester, 1);

      await tapDeleteButton(tester, 0);

      FloatingActionButton button = findPointInTimeButton(tester, 0);
      expect(button.onPressed, isNull);
    },
  );

  testWidgets(
    'Undoing creation of active point in time should select other point in time',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TimeBar()));
      await tapAddButton(tester, 1);

      await tapPointInTimeButton(tester, 1);
      var commandProcessor = getIt.get<CommandProcessor>();
      commandProcessor.undo();
      await tester.pump();

      FloatingActionButton button = findPointInTimeButton(tester, 0);
      expect(button.onPressed, isNull);
    },
  );
}

FloatingActionButton findDeleteButton(WidgetTester tester, int index) {
  var deleteButtonFinder = find.byKey(buildDeleteButtonKey(index));
  var floatingActionButtonFinder = find.descendant(
    of: deleteButtonFinder,
    matching: find.byType(FloatingActionButton),
  );
  FloatingActionButton button = tester.widget(floatingActionButtonFinder);
  return button;
}

StringKey buildDeleteButtonKey(int index) => StringKey(
    "${TimeBar.timeBarPanelsKeyBase}$index${TimeBarPanel.deleteButtonKeyBase}");

Future<void> tapAddButton(WidgetTester tester, int index) async {
  var buttonFinder = find.byKey(buildAddButtonKey(index));
  await tester.tap(buttonFinder);
  await tester.pump();
}

Key buildAddButtonKey(int index) =>
    Key("${TimeBar.addPointInTimeButtonKeyBase}$index");

FloatingActionButton findPointInTimeButton(WidgetTester tester, int index) {
  var buttonFinder = find.byKey(buildPointInTimeButtonKey(index));
  var floatingActionButtonFinder = find.descendant(
    of: buttonFinder,
    matching: find.byType(FloatingActionButton),
  );
  FloatingActionButton button = tester.widget(floatingActionButtonFinder);
  return button;
}

Key buildPointInTimeButtonKey(int index) => Key(
    "${TimeBar.timeBarPanelsKeyBase}$index${TimeBarPanel.pointInTimeButtonKeyBase}");

Future<void> tapDeleteButton(WidgetTester tester, int index) async {
  var buttonFinder = find.byKey(buildDeleteButtonKey(index));
  await tester.tap(buttonFinder);
  await tester.pump();
}

Future<void> tapPointInTimeButton(WidgetTester tester, int index) async {
  var buttonFinder = find.byKey(buildPointInTimeButtonKey(index));
  await tester.tap(buttonFinder);
  await tester.pump();
}
