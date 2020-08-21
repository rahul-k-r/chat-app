import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class GroupChatScreen extends StatefulWidget {
  final chatId;
  final groupName;

  GroupChatScreen(this.chatId, this.groupName);
  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      if (msg['notification']['body'] != 'timeStampMarker') print(msg);
      return;
    }, onLaunch: (msg) {
      if (msg['notification']['body'] != 'timeStampMarker') print(msg);
      return;
    }, onResume: (msg) {
      if (msg['notification']['body'] != 'timeStampMarker') print(msg);
      return;
    });
    fbm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupName,
          style: GoogleFonts.satisfy(fontWeight: FontWeight.bold),
        ),
        actions: [],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(widget.chatId, true),
            ),
            NewMessage('lol', 'chat'),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final uid;
  final chatId;
  final username;
  ChatScreen(this.uid, this.chatId, this.username);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.username,
          style: GoogleFonts.satisfy(fontWeight: FontWeight.bold),
        ),
        actions: [],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(widget.chatId, false),
            ),
            NewMessage(widget.uid, widget.chatId),
          ],
        ),
      ),
    );
  }
}
