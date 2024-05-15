import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/view/commands/view_command.dart';
import 'package:ceal_chronicler_f/view/templates/character_view_template.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';

import '../../characters/model/character_id.dart';

class OpenCharacterViewCommand extends ViewCommand {
  final CharacterRepository characterRepository = getIt<CharacterRepository>();
  final ViewRepository viewRepository = getIt.get<ViewRepository>();
  final CharacterId id;

  OpenCharacterViewCommand(this.id);

  @override
  void execute() =>
      viewRepository.activeViewTemplate = CharacterViewTemplate(id);

  @override
  bool get isValid => characterRepository.contains(id);
}
