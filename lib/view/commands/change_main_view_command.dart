import '../../get_it_context.dart';
import '../templates/main_view_template.dart';
import '../view_repository.dart';
import 'view_command.dart';

abstract class ChangeMainViewCommand extends ViewCommand {
  final ViewRepository viewRepository = getIt.get<ViewRepository>();
  final MainViewTemplate _template;
  MainViewTemplate? _previousTemplate;

  ChangeMainViewCommand(this._template);

  @override
  void execute() {
    _previousTemplate = viewRepository.mainViewTemplate;
    redo();
  }

  @override
  bool get isUndoPossible {
    if (_previousTemplate != null) {
      return _previousTemplate!.isValid &&
          _previousTemplate! != viewRepository.mainViewTemplate;
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
  bool get isRedoPossible =>
      (_template.isValid && _template != viewRepository.mainViewTemplate);

  @override
  void redo() {
    viewRepository.mainViewTemplate = _template;
  }

  @override
  String get executeMessage => "Opened ${_template.identifier}";

  @override
  String get undoMessage {
    return _previousTemplate == null
        ? "Undo of ChangeMainViewCommand should not be possible because _previousTemplate is null"
        : "Opened ${_previousTemplate!.identifier}";
  }
}
