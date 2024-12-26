import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../view/commands/change_main_view_command.dart';
import '../../view/view_processor.dart';
import '../model/temporal_entity.dart';
import 'buttons/ceal_text_button.dart';

abstract class TemporalEntityButton<T extends TemporalEntity>
    extends CealTextButton {
  final T entity;
  final viewProcessor = getIt.get<ViewProcessor>();
  final keyFieldResolver = getIt.get<KeyFieldResolver>();
  final pointInTimeRepositoy = getIt.get<PointInTimeRepository>();

  TemporalEntityButton(this.entity, {super.key});

  @override
  void onPressed(BuildContext context) {
    var command = createOpenViewCommand(entity);
    viewProcessor.process(command);
  }

  @override
  String get text {
    return keyFieldResolver.getCurrentValue(entity.name) ?? "";
  }

  @override
  String? get tooltip {
    return "View/Edit $text";
  }

  @override
  bool isEnabled(BuildContext context) {
    return pointInTimeRepositoy.entityIsPresentlyActive(entity);
  }

  @override
  String? getDisabledReason(BuildContext context) {
    PointInTimeId firstAppearance = entity.firstAppearance;
    PointInTimeId? lastAppearance = entity.lastAppearance;
    if (pointInTimeRepositoy.pointIsInTheFuture(firstAppearance)) {
      PointInTime? firstAppearancePoint =
          pointInTimeRepositoy.get(firstAppearance);
      String firstAppearanceString =
          firstAppearancePoint != null ? firstAppearancePoint.name : "unknown";
      return "$entityTypeName is not yet active. First appearance: $firstAppearanceString";
    } else if (lastAppearance != null &&
        pointInTimeRepositoy.pointIsInThePast(lastAppearance)) {
      PointInTime? lastAppearancePoint =
          pointInTimeRepositoy.get(lastAppearance);
      String lastAppearanceString =
          lastAppearancePoint != null ? lastAppearancePoint.name : "unknown";
      return "$entityTypeName is no longer active. Last appearance: $lastAppearanceString";
    }
    return "$entityTypeName is disabled for an unknown reason";
  }

  String get entityTypeName;

  ChangeMainViewCommand createOpenViewCommand(T entity);
}
