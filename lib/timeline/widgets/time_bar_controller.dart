import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:flutter/material.dart';

import '../../characters/model/character.dart';
import '../../commands/command_processor.dart';
import '../../get_it_context.dart';
import '../commands/create_point_in_time_command.dart';
import '../commands/delete_point_in_time_command.dart';
import '../commands/rename_point_in_time_command.dart';
import '../model/point_in_time.dart';
import '../model/point_in_time_repository.dart';

class TimeBarController extends ChangeNotifier {
  static const String lastPointDeletionForbiddenReason =
      "The last point in time can't be deleted";
  static const String incidentsPresentDeletionForbiddenReason =
      "A point in time with incidents can't be deleted";
  static const String unknownDeletionForbiddenReason =
      "The reason why this point in time can't be deleted is unknown\n"
      "This might indicate a bug";

  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _characterRepository = getIt.get<CharacterRepository>();
  final _commandProcessor = getIt.get<CommandProcessor>();

  TimeBarController() {
    _commandProcessor.addListener(() => notifyListeners());
  }

  List<PointInTime> get pointsInTime => _pointInTimeRepository.pointsInTime;

  bool canPointBeDeleted(PointInTime point) =>
      _pointInTimeRepository.pointsInTime.length > 1 &&
      point.incidentReferences.isEmpty &&
      _getFirstCharacterApperancesAt(point).isEmpty;

  void addPointInTimeAtIndex(int index) {
    var command = CreatePointInTimeCommand(index);
    _commandProcessor.process(command);
  }

  void delete(PointInTime point) {
    var command = DeletePointInTimeCommand(point);
    _commandProcessor.process(command);
  }

  void rename(PointInTime point, String newName) {
    var command = RenamePointInTimeCommand(point, newName);
    _commandProcessor.process(command);
  }

  String getPointDeleteButtonDisabledReason(PointInTime point) {
    List<String> reasonsWhyPointCantBeDeleted =
        _getReasonsWhyPointCantBeDeleted(point);
    if (reasonsWhyPointCantBeDeleted.isEmpty) {
      return unknownDeletionForbiddenReason;
    } else {
      return _consolidateReasonsWhyPointCantBeDeleted(
        reasonsWhyPointCantBeDeleted,
      );
    }
  }

  List<String> _getReasonsWhyPointCantBeDeleted(PointInTime point) {
    List<String> reasonsWhyPointCantBeDeleted = [];
    if (_pointInTimeRepository.pointsInTime.length < 2) {
      reasonsWhyPointCantBeDeleted.add(lastPointDeletionForbiddenReason);
    }
    if (point.incidentReferences.isNotEmpty) {
      reasonsWhyPointCantBeDeleted.add(incidentsPresentDeletionForbiddenReason);
    }
    List<Character> firstCharacterApperances =
        _getFirstCharacterApperancesAt(point);
    if (firstCharacterApperances.isNotEmpty) {
      reasonsWhyPointCantBeDeleted.add(
        _buildFirstAppearanceDeletionForbiddenReason(
          firstCharacterApperances,
        ),
      );
    }
    return reasonsWhyPointCantBeDeleted;
  }

  List<Character> _getFirstCharacterApperancesAt(PointInTime point) {
    List<Character> charactersWithFirstAppearanceAtPoint = [];
    for (Character character in _characterRepository.content) {
      if (character.firstAppearance == point.id) {
        charactersWithFirstAppearanceAtPoint.add(character);
      }
    }
    return charactersWithFirstAppearanceAtPoint;
  }

  String _buildFirstAppearanceDeletionForbiddenReason(
    List<Character> firstCharacterApperances,
  ) {
    if (firstCharacterApperances.length == 1) {
      return "First appearance of ${firstCharacterApperances.first.name}";
    }
    String reason = "First appearance of the following characters:";
    for (Character character in firstCharacterApperances) {
      reason += "\n ● ${character.name}";
    }
    return reason;
  }

  String _consolidateReasonsWhyPointCantBeDeleted(
      List<String> reasonsWhyPointCantBeDeleted) {
    String reasons =
        "This point in time can't be deleted for the following reasons:";
    for (String reason in reasonsWhyPointCantBeDeleted) {
      reasons += "\n● $reason";
    }
    return reasons;
  }
}
