import '../../../../commands/command.dart';
import '../../utils/model/temporal_entity.dart';
import '../model/attribute.dart';

class CreateAttributeCommand extends Command {
  Attribute? _createdAttribute;
  final TemporalEntity entity;

  CreateAttributeCommand(this.entity);

  @override
  void execute() {
    _createdAttribute ??= Attribute();
    entity.attributes.add(_createdAttribute!);
  }

  @override
  String get executeMessage => "Created new Attribute";

  @override
  void undo() {
    if (_createdAttribute != null) {
      entity.attributes.remove(_createdAttribute!);
    }
  }

  @override
  String get undoMessage =>
      "Undid creation of new Attribute";
}
