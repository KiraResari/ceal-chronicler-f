import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/commands/view_command.dart';

class ActivatePointInTimeCommand extends ViewCommand {
  final PointInTimeRepository _repository = getIt.get<PointInTimeRepository>();
  final PointInTimeId _id;
  PointInTimeId? _previousActivePointInTimeId;

  ActivatePointInTimeCommand(this._id);

  @override
  bool get isExecutePossible => _repository.contains(_id);

  @override
  void execute() {
    _previousActivePointInTimeId = _repository.activePointInTime.id;
    _repository.activatePointInTime(_id);
  }

  @override
  bool get isUndoPossible {
    if (_previousActivePointInTimeId != null) {
      return _repository.contains(_previousActivePointInTimeId!);
    }
    return false;
  }

  @override
  void undo() {
    if (_previousActivePointInTimeId != null) {
      _repository.activatePointInTime(_previousActivePointInTimeId!);
    }
  }
}
