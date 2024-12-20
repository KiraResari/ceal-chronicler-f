import 'package:ceal_chronicler_f/view/commands/open_location_view_command.dart';
import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../utils/widgets/buttons/ceal_text_button.dart';
import '../../view/view_processor.dart';
import '../model/location.dart';

class LocationButton extends CealTextButton {
  final viewProcessor = getIt.get<ViewProcessor>();
  final keyFieldResolver = getIt.get<KeyFieldResolver>();

  final Location location;

  LocationButton(this.location, {super.key});

  @override
  void onPressed(BuildContext context) {
    var command = OpenLocationViewCommand(location);
    viewProcessor.process(command);
  }

  @override
  String get text {
    return keyFieldResolver.getCurrentValue(location.name) ?? "";
  }

  @override
  String? get tooltip {
    return "View/Edit $text";
  }
}
