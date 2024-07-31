import 'package:ceal_chronicler_f/characters/model/character_repository.dart';
import 'package:ceal_chronicler_f/commands/processor_listener.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_info.dart';
import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';

import '../../characters/model/character.dart';
import '../../get_it_context.dart';
import '../../key_fields/key_field_info_group.dart';
import '../commands/create_point_in_time_command.dart';
import '../commands/delete_point_in_time_command.dart';
import '../commands/rename_point_in_time_command.dart';
import '../model/point_in_time.dart';
import '../model/point_in_time_repository.dart';

class TimeBarController extends ProcessorListener {
  static const String lastPointDeletionForbiddenReason =
      "The last point in time can't be deleted";
  static const String incidentsPresentDeletionForbiddenReason =
      "A point in time with incidents can't be deleted";
  static const String unknownDeletionForbiddenReason =
      "The reason why this point in time can't be deleted is unknown\n"
      "This might indicate a bug";

  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final _characterRepository = getIt.get<CharacterRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();

  TimeBarController() : super();

  List<PointInTime> get pointsInTime => _pointInTimeRepository.pointsInTime;

  bool canPointBeDeleted(PointInTime point) =>
      _pointInTimeRepository.pointsInTime.length > 1 &&
      point.incidentReferences.isEmpty &&
      _getFirstCharacterApperancesAt(point).isEmpty &&
      _getBlockingKeysAt(point).isEmpty;

  List<Character> _getFirstCharacterApperancesAt(PointInTime point) {
    List<Character> charactersWithFirstAppearanceAtPoint = [];
    for (Character character in _characterRepository.content) {
      if (character.firstAppearance == point.id) {
        charactersWithFirstAppearanceAtPoint.add(character);
      }
    }
    return charactersWithFirstAppearanceAtPoint;
  }

  List<KeyFieldInfoGroup> _getBlockingKeysAt(PointInTime point) {
    List<KeyFieldInfoGroup> blockingKeys = [];
    blockingKeys.addAll(_findBlockingKeysInCharactersAt(point));
    return blockingKeys;
  }

  List<KeyFieldInfoGroup> _findBlockingKeysInCharactersAt(PointInTime point) {
    List<KeyFieldInfoGroup> blockingKeys = [];
    for (Character character in _characterRepository.content) {
      List<KeyFieldInfo> keyFieldInfos = character.getKeyInfosAt(point.id);
      if (keyFieldInfos.isNotEmpty) {
        String characterName =
        _keyFieldResolver.getCurrentValue(character.name);
        String groupName = "Character '$characterName'";
        var group = KeyFieldInfoGroup(groupName, keyFieldInfos);
        blockingKeys.add(group);
      }
    }
    return blockingKeys;
  }

  void addPointInTimeAtIndex(int index) {
    var command = CreatePointInTimeCommand(index);
    commandProcessor.process(command);
  }

  void delete(PointInTime point) {
    var command = DeletePointInTimeCommand(point);
    commandProcessor.process(command);
  }

  void rename(PointInTime point, String newName) {
    var command = RenamePointInTimeCommand(point, newName);
    commandProcessor.process(command);
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
    List<KeyFieldInfoGroup> blockingKeys = _getBlockingKeysAt(point);
    if (blockingKeys.isNotEmpty) {
      reasonsWhyPointCantBeDeleted.add(
        _buildBlockingKeysReason(blockingKeys),
      );
    }
    return reasonsWhyPointCantBeDeleted;
  }

  String _buildFirstAppearanceDeletionForbiddenReason(
    List<Character> firstCharacterApperances,
  ) {
    if (firstCharacterApperances.length == 1) {
      Character character = firstCharacterApperances[0];
      String characterName = _keyFieldResolver.getCurrentValue(character.name);
      return "First appearance of character '$characterName'";
    }
    String reason = "First appearance of the following characters:";
    for (Character character in firstCharacterApperances) {
      String characterName = _keyFieldResolver.getCurrentValue(character.name);
      reason += "\n ● $characterName";
    }
    return reason;
  }

  String _buildBlockingKeysReason(List<KeyFieldInfoGroup> blockingKeys) {
    if (blockingKeys.length == 1 && blockingKeys[0].keyFieldInfos.length == 1) {
      KeyFieldInfoGroup group = blockingKeys[0];
      KeyFieldInfo info = group.keyFieldInfos[0];
      return "${group.groupName} has a ${info.fieldName} that changed to ${info.value} at this point in time";
    }
    String reason = "";
    if (blockingKeys.length == 1) {
      KeyFieldInfoGroup group = blockingKeys[0];
      reason =
          "{group.groupName} has the following changes at this point in time:";
      for (KeyFieldInfo info in group.keyFieldInfos) {
        reason += "\n ● ${info.fieldName} changed to ${info.value}";
      }
      return reason;
    }
    reason = "The following entities have changes at this point in time:";
    for (KeyFieldInfoGroup group in blockingKeys) {
      reason += "\n ● ${group.groupName}";
      for (KeyFieldInfo info in group.keyFieldInfos) {
        reason += "\n   ⮡ ${info.fieldName} changed to ${info.value}";
      }
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
