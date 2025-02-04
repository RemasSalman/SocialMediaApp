import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p8/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance
        .currentUser!; // Retrieves and returns the currently signed-in user from Firebase authentication

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(236, 255, 255, 255),
        surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'CHAT',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatsnapshots) {
          if (chatsnapshots.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatsnapshots.hasData || chatsnapshots.data!.docs.isEmpty) {
            return Center(
              child: Text('No messages yet.'),
            );
          }
          final loadMessages = chatsnapshots.data!.docs;
          return ListView.builder(
            padding: EdgeInsets.only(
              bottom: 40,
              left: 13,
              right: 13,
            ),
            reverse: true,
            itemCount: loadMessages.length,
            itemBuilder: (context, index) {
              
              final chatMessage = loadMessages[index].data();
              final nextMessage = index + 1 < loadMessages.length
                  ? loadMessages[index + 1].data()
                  : null;
      
              final currentMessageId = chatMessage['userId'];
              final nextMessageId =
                  nextMessage != null ? nextMessage['userId'] : null;
              final nextUserIsSame = nextMessageId == currentMessageId;
      
              if (nextUserIsSame) {
                return MessageBubble.next(
                    message: chatMessage['text'],
                    isMe: authenticatedUser.uid == currentMessageId);
              } else {
                return MessageBubble.first(
                    userImage: chatMessage['userImage'],
                    username: chatMessage['username'],
                    message: chatMessage['text'],
                    isMe: authenticatedUser.uid == currentMessageId);
              }
            },
          );
        },
      ),
    );
  }
}
