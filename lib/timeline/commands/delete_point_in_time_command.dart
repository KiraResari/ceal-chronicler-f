import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../model/point_in_time.dart';
import '../model/point_in_time_repository.dart';
import '../time_processor.dart';

class DeletePointInTimeCommand extends Command {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _timeProcessor = getIt.get<TimeProcessor>();
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
    PointInTime activePoint = _timeProcessor.activePointInTime;
    if (activePoint == _pointToDelete) {
      _deletedPointWasActivePoint = true;
      PointInTime newActivePoint = _determineNewActivePoint();
      _timeProcessor.activePointInTime = newActivePoint;
    }
  }

  PointInTime _determineNewActivePoint() {
    if (_pointToDelete == _pointInTimeRepository.last) {
      return _pointInTimeRepository.pointsInTime[_deletionIndex! - 1];
    }
    return _pointInTimeRepository.pointsInTime[_deletionIndex! + 1];
  }

  @override
  void undo() {
    if (_deletionIndex != null) {
      _pointInTimeRepository.createAtIndex(_deletionIndex!, _pointToDelete);
      if (_deletedPointWasActivePoint) {
        _timeProcessor.activePointInTime = _pointToDelete;
      }
    }
  }

  @override
  String get executeMessage => "Deleted Point in Time '${_pointToDelete.name}'";

  @override
  String get undoMessage =>
      "Restored deleted Point in Time '${_pointToDelete.name}'";
}
