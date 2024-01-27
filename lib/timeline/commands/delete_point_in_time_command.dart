import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../point_in_time.dart';
import '../point_in_time_repository.dart';

class DeletePointInTimeCommand extends Command {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  int? _deletionIndex;
  final PointInTime _pointToDelete;

  DeletePointInTimeCommand(this._pointToDelete);

  @override
  void execute() {
    _deletionIndex = _pointInTimeRepository.getPointIndex(_pointToDelete);
    _pointInTimeRepository.remove(_pointToDelete);
  }

  @override
  void undo() {
    if (_deletionIndex != null) {
      _pointInTimeRepository.createAtIndex(_deletionIndex!, _pointToDelete);
    }
  }

  @override
  String get executeMessage => "Deleted Point in Time '${_pointToDelete.name}'";

  @override
  String get undoMessage =>
      "Restored deleted Point in Time '${_pointToDelete.name}'";
}
