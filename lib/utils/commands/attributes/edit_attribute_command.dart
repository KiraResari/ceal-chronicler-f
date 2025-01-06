import '../../../commands/command.dart';
import '../../model/attribute.dart';

class EditAttributeCommand extends Command {
  final Attribute attribute;
  final String newName;
  String? _oldName;

  EditAttributeCommand(this.attribute, this.newName);

  @override
  void execute() {
    _oldName = attribute.name;
    attribute.name = newName;
  }

  @override
  String get executeMessage =>
      "Renamed Attribute from '$_oldNameOrUnknown' to $newName";

  @override
  void undo() {
    if (_oldName != null) {
      attribute.name = _oldName!;
    }
  }

  @override
  String get undoMessage =>
      "Renamed Attribute back from '$newName' to $_oldNameOrUnknown";

  String get _oldNameOrUnknown {
    if (_oldName != null) {
      return _oldName!;
    }
    return "Unknown";
  }
}
