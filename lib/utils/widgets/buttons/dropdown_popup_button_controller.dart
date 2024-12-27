import 'package:flutter/material.dart';

import '../../../commands/command.dart';
import '../../../commands/command_processor.dart';
import '../../../get_it_context.dart';

abstract class DropdownPopupButtonController<T> {
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

  void onConfirm(T? selection) {
    if (selection != null) {
      Command command = buildCommand(selection);
      _commandProcessor.process(command);
    }
  }

  Command buildCommand(T selection);
}
