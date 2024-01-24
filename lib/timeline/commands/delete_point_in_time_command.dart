import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../point_in_time.dart';
import '../point_in_time_repository.dart';

class DeletePointInTimeCommand extends Command {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  int? _deletionIndex;
  final PointInTime pointToDelete;

  DeletePointInTimeCommand(this.pointToDelete);

  @override
  void execute() {
    _deletionIndex = _pointInTimeRepository.getPointIndex(pointToDelete);
    _pointInTimeRepository.remove(pointToDelete);
  }

  @override
  void undo() {
    if (_deletionIndex != null) {
      _pointInTimeRepository.createAtIndex(_deletionIndex!, pointToDelete);
    }
  }
}
