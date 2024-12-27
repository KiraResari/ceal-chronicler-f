import '../../../get_it_context.dart';
import '../../../utils/widgets/temporal_overview_controller.dart';
import '../../model/location.dart';
import '../../model/location_id.dart';
import '../../model/location_repository.dart';

class LocationOverviewController
    extends TemporalOverviewController<Location, LocationId> {
  LocationOverviewController() : super(getIt.get<LocationRepository>());
}
