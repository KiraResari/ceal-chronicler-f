import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/widgets/buttons/small_circular_button.dart';
import '../model/character.dart';
import 'character_view_controller.dart';

class DeleteLastAppearanceButton extends SmallCircularButton {
  final Character character;

  const DeleteLastAppearanceButton({super.key, required this.character})
      : super(icon: Icons.delete);

  @override
  void onPressed(BuildContext context) {
    var controller = context.read<CharacterViewController>();
    controller.deleteLastAppearance(character);
  }

  @override
  String? get tooltip => "Delete last appearance";
}
