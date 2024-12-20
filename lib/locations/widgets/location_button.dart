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
    //TODO: Implement
  }

  @override
  String get text {
    return keyFieldResolver.getCurrentValue(location.name);
  }

  @override
  String? get tooltip {
    String characterName = keyFieldResolver.getCurrentValue(location.name);
    return "View/Edit $characterName";
  }
}
