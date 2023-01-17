import 'package:ceal_chronicler_f/ceal_chronicler_f.dart';
import 'package:ceal_chronicler_f/characters/character_selection_view/character_selection_view.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/title_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() => initializeGetItContext());
  tearDown(() => getIt.reset());

  testWidgets(
    'Title screen should have welcome message',
    (WidgetTester tester) async {
      await tester.pumpWidget(const CealChroniclerF());

      expect(find.text(TitleView.welcomeMessage), findsOneWidget);
    },
  );

  testWidgets(
    'Title screen should have start button with correct message',
    (WidgetTester tester) async {
      await tester.pumpWidget(const CealChroniclerF());

      expect(find.text(TitleView.startButtonText), findsOneWidget);
    },
  );

  testWidgets(
    'Navigating to Character Selection should work',
    (WidgetTester tester) async {
      await tester.pumpWidget(const CealChroniclerF());

      await tester.tap(find.bySemanticsLabel(TitleView.startButtonText));
      await tester.pump();

      expect(find.text(CharacterSelectionView.titleText), findsOneWidget);
    },
  );
}
