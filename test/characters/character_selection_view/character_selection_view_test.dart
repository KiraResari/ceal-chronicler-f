import 'package:ceal_chronicler_f/ceal_chronicler_f.dart';
import 'package:ceal_chronicler_f/characters/character_name_field.dart';
import 'package:ceal_chronicler_f/characters/character_selection_view/character_selection_view_old.dart';
import 'package:ceal_chronicler_f/characters/character_view/character_view.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/title_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() => initializeGetItContext());
  tearDown(() => getIt.reset());

  testWidgets(
    "Character Selection View should have Add button",
    (WidgetTester tester) async {
      await navigateToCharacterSelectionView(tester);

      expect(find.text(CharacterSelectionViewOld.addCharacterButtonText),
          findsOneWidget);
    },
  );

  testWidgets(
    "Clicking Add Button should add a character",
    (WidgetTester tester) async {
      await navigateToCharacterSelectionViewAndAddCharacter(tester);

      expect(find.text(CharacterNameField.defaultValue), findsOneWidget);
    },
  );

  testWidgets(
    "Clicking Character Button should open character view",
    (WidgetTester tester) async {
      await navigateToCharacterSelectionViewAndAddCharacter(tester);

      await tester.tap(find.bySemanticsLabel(CharacterNameField.defaultValue));
      await tester.pump();

      expect(find.text(CharacterView.backButtonText), findsOneWidget);
    },
  );
}

Future<void> navigateToCharacterSelectionViewAndAddCharacter(
    WidgetTester tester) async {
  await navigateToCharacterSelectionView(tester);

  expect(
      find.text(CharacterSelectionViewOld.addCharacterButtonText), findsOneWidget);
  await tester.tap(
      find.bySemanticsLabel(CharacterSelectionViewOld.addCharacterButtonText));
  await tester.pump();
}

Future<void> navigateToCharacterSelectionView(WidgetTester tester) async {
  await tester.pumpWidget(const CealChroniclerF());

  await tester.tap(find.bySemanticsLabel(TitleView.startButtonText));
  await tester.pump();
}
