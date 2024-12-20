import '../../utils/widgets/temporal_entity_view.dart';
import '../model/location.dart';
import 'location_view_controller.dart';

class LocationView
    extends TemporalEntityView<Location, LocationViewController> {
  const LocationView({super.key, required Location location})
      : super(entity: location);

  @override
  LocationViewController createController() {
    return LocationViewController(entity);
  }
}
