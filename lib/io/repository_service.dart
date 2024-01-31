import '../get_it_context.dart';
import '../timeline/model/point_in_time.dart';
import '../timeline/model/point_in_time_repository.dart';
import 'chronicle.dart';

class RepositoryService {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();

  Chronicle assembleChronicle() {
    List<PointInTime> pointsInTime = _pointInTimeRepository.pointsInTime;
    return Chronicle(pointsInTime: pointsInTime);
  }

  void distributeChronicle(Chronicle chronicle) {
    _pointInTimeRepository.pointsInTime = chronicle.pointsInTime;
  }
}
