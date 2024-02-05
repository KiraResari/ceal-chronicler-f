import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../model/point_in_time.dart';
import '../model/point_in_time_repository.dart';

class DeletePointInTimeCommand extends Command {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  int? _deletionIndex;
  final PointInTime _pointToDelete;
  bool _deletedPointWasActivePoint = false;

  DeletePointInTimeCommand(this._pointToDelete);

  @override
  void execute() {
    _deletionIndex = _pointInTimeRepository.getPointIndex(_pointToDelete);
    _handleDeletingOfActivePointInTime();
    _pointInTimeRepository.remove(_pointToDelete);
  }

  void _handleDeletingOfActivePointInTime() {
    PointInTime activePoint = _pointInTimeRepository.activePointInTime;
    if (activePoint == _pointToDelete) {
      _deletedPointWasActivePoint = true;
    }
  }

  @override
  void undo() {
    if (_deletionIndex != null) {
      _pointInTimeRepository.addAtIndex(_deletionIndex!, _pointToDelete);
      if (_deletedPointWasActivePoint) {
        _pointInTimeRepository.activePointInTime = _pointToDelete;
      }
    }
  }

  @override
  String get executeMessage => "Deleted Point in Time '${_pointToDelete.name}'";

  @override
  String get undoMessage =>
      "Restored deleted Point in Time '${_pointToDelete.name}'";
}
