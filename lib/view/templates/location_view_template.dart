import '../../get_it_context.dart';
import '../../locations/model/location.dart';
import '../../locations/model/location_repository.dart';
import '../../locations/widgets/location_view.dart';
import '../../main_view/main_view_candidate.dart';
import 'main_view_template.dart';
import 'temporally_limited_template.dart';

class LocationViewTemplate extends TemporallyLimitedTemplate<Location>
    implements MainViewTemplate {
  final _locationRepository = getIt<LocationRepository>();

  LocationViewTemplate(super.location);

  @override
  MainViewCandidate get associatedView => LocationView(location: entity);

  @override
  bool get isValid => _locationRepository.contains(entity.id);

  @override
  String get identifier=> "Location '$currentName'";
}
