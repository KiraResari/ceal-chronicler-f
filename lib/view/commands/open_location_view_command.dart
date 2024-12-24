import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../locations/model/location.dart';
import '../templates/location_view_template.dart';
import 'change_main_view_command.dart';

class OpenLocationViewCommand extends ChangeMainViewCommand {
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();

  Location location;

  OpenLocationViewCommand(this.location)
      : super(LocationViewTemplate(location));

  @override
  String toString() {
    return 'OpenLocationViewCommand{Target: $location; Can execute: $isRedoPossible; Can undo: $isUndoPossible}';
  }

  String get getCharacterNameOrUnknown {
    String? name = _keyFieldResolver.getCurrentValue(location.name);
    return name ?? "unknown";
  }
}
