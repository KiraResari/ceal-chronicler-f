import '../../locations/model/location.dart';
import '../templates/location_view_template.dart';
import 'change_main_view_command.dart';

class OpenLocationViewCommand extends ChangeMainViewCommand {
  Location location;

  OpenLocationViewCommand(this.location)
      : super(LocationViewTemplate(location));

  @override
  String toString() {
    return 'OpenLocationViewCommand{Target: $location; Can execute: $isRedoPossible; Can undo: $isUndoPossible}';
  }
}
