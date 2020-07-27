import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/chat_screen.dart';

class ChatSelector extends StatelessWidget {
  final double width;
  final double height;

  ChatSelector(this.height, this.width);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: Border.symmetric(
              vertical: BorderSide(
            color: Colors.grey,
            width: 1,
          )),
        ),
        child: Row(
          key: UniqueKey(),
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            InkWell(
              child: CircleAvatar(
                radius: height * 0.35,
                backgroundColor: Colors.grey,
                backgroundImage:
                    ExactAssetImage('assets/images/icon-avatar-default.png'),
              ),
              onTap: () {
                showDialog(context: context, child: Text('Details screen WIP'));
              },
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('User'),
                        Spacer(),
                        Text('time'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Text('message'),
                        Spacer(),
                        Text('count'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(),
          ),
        );
      },
    );
  }
}
