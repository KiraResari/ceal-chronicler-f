import 'ceal_icon_button.dart';

abstract class SmallCircularButton extends CealIconButton {
  const SmallCircularButton({
    super.key,
    required super.icon,
  }) : super(height: 24, width: 24);
}
