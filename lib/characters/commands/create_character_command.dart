import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';

import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../../view/templates/character_view_template.dart';
import '../../view/templates/main_view_template.dart';
import '../../view/templates/overview_view_template.dart';
import '../../view/view_repository.dart';
import '../model/character.dart';
import '../model/character_repository.dart';

class CreateCharacterCommand extends Command {
  final _characterRepository = getIt.get<CharacterRepository>();
  final _viewRepository = getIt.get<ViewRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();
  final PointInTimeId _pointId;
  Character? _createdCharacter;

  CreateCharacterCommand(this._pointId);

  @override
  void execute() {
    _createdCharacter ??= Character(_pointId);
    _characterRepository.add(_createdCharacter!);
  }

  @override
  String get executeMessage => "Created new Character";

  @override
  void undo() {
    if (_createdCharacter != null) {
      _characterRepository.remove(_createdCharacter!);
      _returnToOverviewViewIfCharacterViewWasOpen();
    }
  }

  void _returnToOverviewViewIfCharacterViewWasOpen() {
    MainViewTemplate mainViewTemplate = _viewRepository.mainViewTemplate;
    if (mainViewTemplate is CharacterViewTemplate &&
        mainViewTemplate.character == _createdCharacter!) {
      _viewRepository.mainViewTemplate = OverviewViewTemplate();
    }
  }

  @override
  String get undoMessage =>
      "Undid creation of Character $_characterNameOrNothing";

  String get _characterNameOrNothing {
    if (_createdCharacter != null) {
      String name = _keyFieldResolver.getCurrentValue(_createdCharacter!.name);
      return "'$name'";
    }
    return "";
  }
}
