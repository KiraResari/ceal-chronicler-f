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
  final bool isActive;

  LocationButton(this.location, {super.key, this.isActive = true});

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

  @override
  bool isEnabled(BuildContext context) {
    return isActive;
  }

  @override
  String? getDisabledReason(BuildContext context) {
    String name = keyFieldResolver.getCurrentValue(location.name) ?? "unknown";
    return "Location '$name' does not exist at this point in time";
  }
}
