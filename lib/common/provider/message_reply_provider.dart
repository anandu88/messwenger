import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messwenger/common/enums/messages_enum.dart';

class MessageReplay{
  final String message;
   final bool isMe;
  final MessageEnum messageEnum;

  MessageReplay(this.message, this.messageEnum, this.isMe);


}
final messageReplayProvider=StateProvider<MessageReplay?>((ref) => null);