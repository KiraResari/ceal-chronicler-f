import 'package:flutter/material.dart';

import '../../../commands/command.dart';
import '../../../commands/command_processor.dart';
import '../../../get_it_context.dart';

abstract class EditDropdownButtonController<T> {
  final _commandProcessor = getIt.get<CommandProcessor>();

  List<DropdownMenuEntry<T>> get validMenuEntries {
    return validEntries.map((entry) => mapToDropdownMenuEntry(entry)).toList();
  }

  List<T> get validEntries;

  DropdownMenuEntry<T> mapToDropdownMenuEntry(T entry) {
    String label = getLabel(entry);
    return DropdownMenuEntry<T>(
      value: entry,
      label: label,
    );
  }

  String getLabel(T entry);

  void update(T? newValue) {
    if (newValue != null) {
      Command command = buildCommand(newValue);
      _commandProcessor.process(command);
    }
  }

  Command buildCommand(T newValue);
}
