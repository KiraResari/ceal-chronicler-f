import '../../../../commands/command.dart';
import '../../utils/model/temporal_entity.dart';
import '../model/temporal_attribute.dart';

class CreateTemporalAttributeCommand extends Command {
  TemporalAttribute? _createdAttribute;
  final TemporalEntity entity;

  CreateTemporalAttributeCommand(this.entity);

  @override
  void execute() {
    _createdAttribute ??= TemporalAttribute();
    entity.temporalAttributes.add(_createdAttribute!);
  }

  @override
  String get executeMessage => "Created new temporal attribute";

  @override
  void undo() {
    if (_createdAttribute != null) {
      entity.temporalAttributes.remove(_createdAttribute!);
    }
  }

  @override
  String get undoMessage =>
      "Undid creation of new temporal attribute";
}
