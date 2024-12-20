import '../../get_it_context.dart';
import '../../locations/model/location.dart';
import '../../locations/model/location_id.dart';
import '../../locations/model/location_repository.dart';
import '../../locations/widgets/location_view.dart';
import '../../main_view/main_view_candidate.dart';
import 'temporally_limited_template.dart';

class LocationViewTemplate
    extends TemporallyLimitedTemplate<Location, LocationId> {
  LocationViewTemplate(location) : super(location, getIt<LocationRepository>());

  @override
  MainViewCandidate get associatedView => LocationView(location: entity);

  @override
  String get identifier => "Location '$currentName'";
}
