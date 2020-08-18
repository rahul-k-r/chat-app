import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../chat/message_bubble.dart';

class Messages extends StatelessWidget {
  Messages(this.chatId, this.isGroup);
  final String chatId;
  final bool isGroup;
  QuerySnapshot cache;
  String userId = '';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: UniqueKey(),
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        userId = futureSnapshot.data.uid;
        return StreamBuilder(
            initialData: cache,
            stream: isGroup
                ? Firestore.instance
                    .collection('chat')
                    .orderBy(
                      'createdAt',
                      descending: true,
                    )
                    .snapshots()
                : Firestore.instance
                    .collection('chats/$userId/chat/$chatId/messages')
                    .orderBy(
                      'createdAt',
                      descending: true,
                    )
                    .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              cache = chatSnapshot.data;
              final chatDocs = cache.documents;
              final width = MediaQuery.of(context).size.width * 0.125;

              return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length + 1,
                  itemBuilder: (ctx, index) {
                    if (index == 0)
                      return SizedBox(
                        height: 5,
                      );

                    _readByMethod(chatDocs, index, futureSnapshot.data.uid);

                    return MessageBubble(
                      chatDocs[index - 1]['text'],
                      chatDocs[index - 1]['username'],
                      chatDocs[index - 1]['userImage'],
                      chatDocs[index - 1]['userId'] == futureSnapshot.data.uid,
                      chatDocs[index - 1]['createdAt'],
                      width,
                      (chatDocs[index - 1]['count'] > 1),
                      isGroup,
                      key: ValueKey(chatDocs[index - 1].documentID),
                    );
                  });
            });
      },
    );
  }

  void _readByMethod(List<DocumentSnapshot> chatDocs, int index, String uid) {
    Timestamp time = Timestamp.now();
    List<dynamic> viewedBy = chatDocs[index - 1]['viewedBy'];
    var isViewed = false;
    if (viewedBy == null) viewedBy = [];

    if (viewedBy != null && viewedBy.length != 0)
      viewedBy.forEach((element) {
        if (element['uid'] == uid) isViewed = true;
      });
    if (!isViewed) {
      viewedBy.add({
        'uid': uid,
        'timeStamp': time,
      });
      if (isGroup)
        Firestore.instance
            .collection('chat')
            .document(chatDocs[index - 1].documentID)
            .updateData({'viewedBy': viewedBy});
      else {
        Firestore.instance
            .collection('chats/$userId/chat/$chatId/messages')
            .document(chatDocs[index - 1].documentID)
            .updateData({'viewedBy': viewedBy});
        Firestore.instance
            .collection('chats/$chatId/chat/$userId/messages')
            .document(chatDocs[index - 1].documentID)
            .updateData({'viewedBy': viewedBy});
      }
    }
  }
}
