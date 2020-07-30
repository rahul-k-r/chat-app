import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/chat_screen.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .orderBy(
              'username',
            )
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = streamSnapshot.data.documents;
          if (chatDocs.length == 0)
            return Center(
              child: Text(
                'No contacts found',
              ),
            );
          final deviceWidth = MediaQuery.of(ctx).size.width;
          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (ctx, itemIndex) {
              return InkWell(
                child: Container(
                  width: deviceWidth,
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 5,
                      ),
                      CircleAvatar(
                        radius: 70 * 0.35,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            NetworkImage(chatDocs[itemIndex]['image_url']),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(chatDocs[itemIndex]['username'])
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
