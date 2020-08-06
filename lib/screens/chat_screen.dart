import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_complete_guide/widgets/chat/messages.dart';
import 'package:flutter_complete_guide/widgets/chat/new_message.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  final chatId;

  ChatScreen(this.chatId);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
          'GroupChat',
          style: GoogleFonts.satisfy(fontWeight: FontWeight.bold),
        ),
        actions: [],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(widget.chatId),
            ),
            NewMessage('lol', 'chat'),
          ],
        ),
      ),
    );
  }
}

class ChatScreen1 extends StatefulWidget {
  final uid;
  final chatId;
  ChatScreen1(this.uid, this.chatId);
  @override
  _ChatScreen1State createState() => _ChatScreen1State();
}

class _ChatScreen1State extends State<ChatScreen1> {
  @override
  void initState() {
    super.initState();
    // final fbm = FirebaseMessaging();
    // fbm.requestNotificationPermissions();
    // fbm.configure(onMessage: (msg) {
    //   if (msg['notification']['body'] != 'timeStampMarker') print(msg);
    //   return;
    // }, onLaunch: (msg) {
    //   if (msg['notification']['body'] != 'timeStampMarker') print(msg);
    //   return;
    // }, onResume: (msg) {
    //   if (msg['notification']['body'] != 'timeStampMarker') print(msg);
    //   return;
    // });
    // fbm.subscribeToTopic('chats/${widget.uid}/chat/${widget.chatId}/messages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GroupChat',
          style: GoogleFonts.satisfy(fontWeight: FontWeight.bold),
        ),
        actions: [],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages1(widget.chatId),
            ),
            NewMessage(widget.uid, widget.chatId),
          ],
        ),
      ),
    );
  }
}
