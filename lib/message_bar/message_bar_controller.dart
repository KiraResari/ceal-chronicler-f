import 'package:ceal_chronicler_f/commands/processor_listener.dart';
import 'package:ceal_chronicler_f/message_bar/message_bar_state.dart';

import '../get_it_context.dart';

class MessageBarController extends ProcessorListener {
  final _messageBarState = getIt.get<MessageBarState>();

  MessageBarController() : super();

  String get message => _messageBarState.statusMessage;

  String get viewProcessorHistoryState => viewProcessor.historyStateString;

  int get viewProcessorHistoryIndex => viewProcessor.index;
}
