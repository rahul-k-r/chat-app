import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/contact_screen.dart';
import '../widgets/chat/chat_selector.dart';

class MainChatScreen extends StatefulWidget {
  @override
  _MainChatScreenState createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  var item = 'all';
  var userId = '';
  var chatId = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: GoogleFonts.satisfy(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          DropdownButton(
              dropdownColor: Theme.of(context).backgroundColor,
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
          userId = futureSnapshot.data.uid;
          return StreamBuilder(
            stream: Firestore.instance
                .collection('chats/$userId/chat')
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
                        child: Icon(
                          Icons.message,
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                        alignment: PlaceholderAlignment.middle,
                      ),
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
                    chatId = chatDocs[chat].documentID;
                    return ChatSelector(
                      70.0,
                      deviceWidth,
                      userId,
                      chatId,
                      chatDocs[chat],
                    );
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
              builder: (context) {
                return ContactScreen(userId);
              },
            ),
          );
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
