import 'package:ceal_chronicler_f/commands/processor_listener.dart';

class MessageBarController extends ProcessorListener {
  MessageBarController() : super();

  String get message => commandProcessor.statusMessage;

  String get viewProcessorHistoryState => viewProcessor.historyStateString;

  int get viewProcessorHistoryIndex => viewProcessor.index;
}
