import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_level.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';

class LocationTestUtils {
  var pointInTimeRepository = getIt.get<PointInTimeRepository>();
  var locationRepository = getIt.get<LocationRepository>();

  Location createLocationAndAddToRepository({
    required LocationLevel locationLevel,
    PointInTimeId? pointInTimeId,
  }) {
    var location =
        Location(pointInTimeId ?? pointInTimeRepository.activePointInTime.id);
    location.locationLevel = locationLevel;
    locationRepository.add(location);
    return location;
  }
}
