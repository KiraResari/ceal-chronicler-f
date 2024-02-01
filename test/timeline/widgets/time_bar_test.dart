import 'package:ceal_chronicler_f/commands/command_processor.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/io/file/file_service.dart';
import 'package:ceal_chronicler_f/io/repository_service.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/timeline/time_processor.dart';
import 'package:ceal_chronicler_f/timeline/widgets/time_bar.dart';
import 'package:ceal_chronicler_f/timeline/widgets/time_bar_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
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
}
