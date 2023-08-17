import '../common/enums/messages_enum.dart';

class Message {
  final String senderId;
  final String recieverid;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String repliedmessagge;
  final String repliedto;
  final MessageEnum repliedmessagetype;
  
  

  Message( {
    required this.senderId,
    required this.recieverid,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.repliedmessagge,
     required this.repliedto,
      required this.repliedmessagetype,
    
  
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverid': recieverid,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
       'repliedmessage': repliedmessagge,
      'repliedto': repliedto,
      'repliedmessagetype': repliedmessagetype.type,
      
      
      
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      recieverid: map['recieverid'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
       repliedmessagetype: (map['repliedmessagetype'] as String).toEnum(), 
       repliedmessagge: map['repliedmessage'] ?? '',
        repliedto: map['repliedto'] ?? '',
      
     
     
    );
  }
}