import 'package:ceal_chronicler_f/view/templates/overview_view_template.dart';

import '../../get_it_context.dart';
import '../templates/main_view_template.dart';
import '../view_repository.dart';
import 'view_command.dart';

class OpenOverviewViewCommand extends ViewCommand {
  final ViewRepository viewRepository = getIt.get<ViewRepository>();
  final MainViewTemplate _template;
  MainViewTemplate? _previousTemplate;

  OpenOverviewViewCommand() : _template = OverviewViewTemplate();

  @override
  void execute() {
    _previousTemplate = viewRepository.mainViewTemplate;
    redo();
  }

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

  @override
  String toString() {
    return 'OpenOverviewViewCommand{}';
  }

  @override
  bool get isRedoPossible => _template.isValid;

  @override
  void redo() {
    viewRepository.mainViewTemplate = _template;
  }
}
