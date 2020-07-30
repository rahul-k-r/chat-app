import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/contact_screen.dart';
import 'package:flutter_complete_guide/widgets/chat/chat_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainChatScreen extends StatefulWidget {
  @override
  _MainChatScreenState createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  var item = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: <Widget>[
          DropdownButton(
              underline: Container(),
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Text(
                    'Direct Message',
                  ),
                  value: 'DM',
                ),
                DropdownMenuItem(
                  child: Text(
                    'Groups',
                  ),
                  value: 'Group',
                ),
                DropdownMenuItem(
                  child: Text(
                    'All',
                  ),
                  value: 'All',
                ),
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Text('Logout'),
                        SizedBox(width: 30),
                        Icon(Icons.exit_to_app),
                      ],
                    ),
                  ),
                  value: 'logout',
                ),
              ],
              onChanged: (itemValue) {
                if (itemValue == 'logout') {
                  FirebaseAuth.instance.signOut();
                  GoogleSignIn().signOut();
                } else
                  setState(() {
                    item = itemValue;
                  });
              }),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: Firestore.instance
                .collection('chats')
                .document(futureSnapshot.data.uid)
                .collection('chat')
                .orderBy('modifiedAt', descending: true)
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data.documents;
              if (chatDocs.length == 0)
                return Center(
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.headline6.color),
                        text: "No chats...To start press the ",
                      ),
                      WidgetSpan(
                          child: Icon(Icons.message),
                          alignment: PlaceholderAlignment.middle),
                      TextSpan(
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.headline6.color),
                        text: " icon to start",
                      )
                    ]),
                  ),
                );
              return Container(
                child: ListView.builder(
                  itemBuilder: (ctx, chat) {
                    final deviceWidth = MediaQuery.of(ctx).size.width;
                    return ChatSelector(70.0, deviceWidth);
                  },
                  itemCount: chatDocs.length,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactScreen(),
            ),
          );
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
