import '../../../get_it_context.dart';
import '../../../utils/widgets/temporal_overview_controller.dart';
import '../../model/location.dart';
import '../../model/location_id.dart';
import '../../model/location_repository.dart';
import '../../model/location_sorter.dart';

class LocationOverviewController
    extends TemporalOverviewController<Location, LocationId> {
  LocationOverviewController() : super(getIt.get<LocationRepository>());

  final _sorter = getIt.get<LocationSorter>();

  List<Location> get sortedActiveLocations {
    var activeLocations = super.entitiesAtActivePointInTime;
    activeLocations.sort(_sorter.sort);
    return activeLocations;
  }
}
