import 'package:flutter/material.dart';

class MainChatScreen extends StatelessWidget {
  var item = 'all';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: <Widget>[
          DropdownButton(
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
              ],
              onChanged: (itemValue) {
                item = itemValue;
              })
        ],
      ),
    );
  }
}
