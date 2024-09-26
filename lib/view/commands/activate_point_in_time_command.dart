import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/commands/view_command.dart';
import 'package:ceal_chronicler_f/view/templates/main_view_template.dart';
import 'package:ceal_chronicler_f/view/templates/temporally_limited_template.dart';
import 'package:ceal_chronicler_f/view/view_repository.dart';

class ActivatePointInTimeCommand extends ViewCommand {
  final PointInTimeRepository _pointInTimeRepository =
      getIt.get<PointInTimeRepository>();
  final ViewRepository _viewRepository = getIt.get<ViewRepository>();
  final PointInTimeId _id;
  PointInTimeId? _previousActivePointInTimeId;

  ActivatePointInTimeCommand(this._id);

  @override
  void execute() {
    _previousActivePointInTimeId = _pointInTimeRepository.activePointInTime.id;
    redo();
  }

  @override
  bool get isUndoPossible {
    if (_previousActivePointInTimeId != null) {
      return _pointIsContainedInRepository &&
          _pointIsNotActiveAlready &&
          _pointIsWithinTemporalBounds;
    }
    return false;
  }

  bool get _pointIsContainedInRepository =>
      _pointInTimeRepository.contains(_previousActivePointInTimeId!);

  bool get _pointIsNotActiveAlready =>
      _previousActivePointInTimeId! !=
      _pointInTimeRepository.activePointInTime.id;

  bool get _pointIsWithinTemporalBounds {
    MainViewTemplate mainViewTemplate = _viewRepository.mainViewTemplate;
    if (mainViewTemplate is TemporallyLimitedTemplate) {
      return (mainViewTemplate as TemporallyLimitedTemplate)
          .existsAt(_previousActivePointInTimeId!);
    }
    return true;
  }

  @override
  void undo() {
    if (_previousActivePointInTimeId != null) {
      _pointInTimeRepository.activatePointInTime(_previousActivePointInTimeId!);
    }
  }

  @override
  String toString() {
    return 'ActivatePointInTimeCommand{Target: $_id; Previous: $_previousActivePointInTimeId; Can execute: $isRedoPossible; Can undo: $isUndoPossible}';
  }

  @override
  bool get isRedoPossible =>
      _pointInTimeRepository.contains(_id) &&
      _id != _pointInTimeRepository.activePointInTime.id;

  @override
  void redo() {
    _pointInTimeRepository.activatePointInTime(_id);
  }
}
