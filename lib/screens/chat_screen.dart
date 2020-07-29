import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_complete_guide/widgets/chat/messages.dart';
import 'package:flutter_complete_guide/widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
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
        title: Text('GroupChat'),
        actions: [],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
