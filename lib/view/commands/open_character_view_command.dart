import '../../characters/model/character_id.dart';
import '../../get_it_context.dart';
import '../templates/character_view_template.dart';
import '../templates/main_view_template.dart';
import '../view_repository.dart';
import 'view_command.dart';

class OpenCharacterViewCommand extends ViewCommand {
  final ViewRepository viewRepository = getIt.get<ViewRepository>();
  final CharacterId id;
  final MainViewTemplate _template;
  MainViewTemplate? _previousTemplate;

  OpenCharacterViewCommand(this.id) : _template = CharacterViewTemplate(id);

  @override
  void execute() {
    _previousTemplate = viewRepository.mainViewTemplate;
    viewRepository.mainViewTemplate = _template;
  }

  @override
  bool get isExecutePossible => _template.isValid;

  @override
  bool get isUndoPossible {
    if (_previousTemplate != null) {
      return _previousTemplate!.isValid;
    }
    return false;
  }

  @override
  void undo() {
    if (_previousTemplate != null) {
      viewRepository.mainViewTemplate = _previousTemplate!;
    }
  }
}
