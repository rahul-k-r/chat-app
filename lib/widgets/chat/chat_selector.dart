import 'package:flutter/material.dart';
import '../../screens/chat_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatSelector extends StatelessWidget {
  final double width;
  final double height;
  final String uid;
  final String chatId;
  final chatDoc;

  ChatSelector(this.height, this.width, this.uid, this.chatId, this.chatDoc);

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
                backgroundImage: chatDoc['image_url'] == null
                    ? ExactAssetImage('assets/images/icon-avatar-default.png')
                    : NetworkImage(chatDoc['image_url']),
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
                        Text(
                          chatDoc['username'] != null
                              ? chatDoc['username']
                              : 'User',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        Spacer(),
                        Text(chatDoc['modifiedAt'] != null
                            ? DateFormat.Hm()
                                .format(chatDoc['modifiedAt'].toDate())
                            : 'time'),
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
            builder: (context) => GroupChatScreen(chatId, 'GroupChat'),
          ),
        );
      },
    );
  }
}
