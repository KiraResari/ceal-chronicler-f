import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../timeline/model/point_in_time_repository.dart';
import '../model/location.dart';
import '../model/location_repository.dart';

class DeleteLocationCommand extends Command {
  final locationRepository = getIt.get<LocationRepository>();
  final pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final resolver = getIt.get<KeyFieldResolver>();
  final Location location;

  DeleteLocationCommand(this.location);

  @override
  void execute() => locationRepository.remove(location);

  @override
  String get executeMessage => "Removed location '$name'";

  @override
  void undo() => locationRepository.add(location);

  @override
  String get undoMessage => "Restored deleted location '$name'";

  get name => resolver.getCurrentValue(location.name);
}
