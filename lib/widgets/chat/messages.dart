import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_complete_guide/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  QuerySnapshot cache;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            initialData: cache,
            stream: Firestore.instance
                .collection('chat')
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
              final width = MediaQuery.of(context).size.width * 0.3;
              print(width);
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, index) => MessageBubble(
                  chatDocs[index]['text'],
                  chatDocs[index]['username'],
                  chatDocs[index]['userImage'],
                  chatDocs[index]['userId'] == futureSnapshot.data.uid,
                  chatDocs[index]['createdAt'],
                  width,
                  key: ValueKey(chatDocs[index].documentID),
                ),
              );
            });
      },
    );
  }
}
