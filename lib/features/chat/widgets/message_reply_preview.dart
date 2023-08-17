import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messwenger/common/provider/message_reply_provider.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});
  void cancelReply(WidgetRef ref){
    ref.read(messageReplayProvider.notifier).update((state) => null);

  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messsgeReply=ref.watch(messageReplayProvider);
    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(
                messsgeReply!.isMe? 'You' :'oposite',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  
                ),
              ),
              ),
              GestureDetector(
                child: const Icon(Icons.close,
                size: 16,),
                onTap: () {
                  
                },
              ),
              const SizedBox(height: 8,),
              Text(messsgeReply.message)

            ],
          )
        ],
      ),
    );
  }
}