import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/io/file/file_service.dart';
import 'package:ceal_chronicler_f/io/repository_service.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/timeline/time_processor.dart';
import 'package:ceal_chronicler_f/timeline/widgets/time_bar.dart';
import 'package:ceal_chronicler_f/timeline/widgets/time_bar_panel.dart';
import 'package:ceal_chronicler_f/utils/string_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    getIt.reset();
    getIt.registerSingleton<PointInTimeRepository>(PointInTimeRepository());
    getIt.registerSingleton<RepositoryService>(RepositoryService());
    getIt.registerSingleton<FileService>(FileService());
    getIt.registerSingleton<TimeProcessor>(TimeProcessor());
    getIt.registerSingleton<CommandProcessor>(CommandProcessor());
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
    'Delete button of first point in time should be disabled',
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
  var addButtonFinder = find.byKey(buildAddButtonKey(index));
  await tester.tap(addButtonFinder);
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
