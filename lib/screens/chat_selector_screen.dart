import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/chat/chat_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                } else
                  setState(() {
                    item = itemValue;
                  });
              }),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (ctx, count) {
            final deviceWidth = MediaQuery.of(ctx).size.width;
            return ChatSelector(70.0, deviceWidth);
          },
          itemCount: 15,
        ),
      ),
    );
  }
}
