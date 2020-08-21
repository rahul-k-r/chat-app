import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NewMessage extends StatefulWidget {
  final String collection;
  final String uid;
  NewMessage(this.uid, this.collection);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextInputAction _textInputAction = TextInputAction.send;
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  void _firebaseUpdateChat(
    String user,
    DocumentSnapshot userData,
    String sentUser,
    DocumentSnapshot sentUserData,
    String message,
  ) {
    Firestore.instance
        .collection('chats/$sentUser/chat')
        .document(user)
        .setData({
      'image_url': userData['image_url'],
      'modifiedAt': Timestamp.now(),
      'username': userData['username'],
      'lastMessage': message,
      'isMine': false,
    });
    Firestore.instance
        .collection('chats/$user/chat')
        .document(sentUser)
        .setData({
      'image_url': sentUserData['image_url'],
      'modifiedAt': Timestamp.now(),
      'username': sentUserData['username'],
      'lastMessage': message,
      'isMine': true,
    });
  }

  void _firebaseAddData(
    String _copiedMessage,
    int _count,
    Timestamp createdAt,
    FirebaseUser user,
    DocumentSnapshot userData,
  ) async {
    final sentUser = 'chats/${widget.collection}/chat';
    final id1 = sentUser + '/${widget.uid}/messages';
    final sender = 'chats/${widget.uid}/chat';
    final id2 = sender + '/${widget.collection}/messages';

    var _message;
    if (widget.collection == 'chat')
      _message = await Firestore.instance.collection('chat').add({
        'text': _copiedMessage,
        'count': _count,
        'createdAt': createdAt,
        'userId': user.uid,
        'username': userData['username'],
        'userImage': userData['image_url'],
        'sent': false,
        'viewedBy': [
          {
            'uid': user.uid,
            'timeStamp': createdAt,
          }
        ]
      });
    else {
      _message = await Firestore.instance.collection(id1).add({
        'text': _copiedMessage,
        'count': _count,
        'createdAt': createdAt,
        'userId': user.uid,
        'username': userData['username'],
        'userImage': userData['image_url'],
        'sent': false,
        'viewedBy': [
          {
            'uid': user.uid,
            'timeStamp': createdAt,
          }
        ]
      });

      await Firestore.instance
          .collection(id2)
          .document(_message.documentID)
          .setData({
        'text': _copiedMessage,
        'count': _count,
        'createdAt': createdAt,
        'userId': user.uid,
        'username': userData['username'],
        'userImage': userData['image_url'],
        'sent': false,
        'viewedBy': [
          {
            'uid': user.uid,
            'timeStamp': createdAt,
          }
        ]
      });
    }
    _message.updateData({'sent': true});
  }

  void _timeStampMarker(
    FirebaseUser user,
    DocumentSnapshot userData,
  ) {
    DateTime date = DateTime.now();
    Timestamp timeStamp = Timestamp.fromDate(
        DateTime.utc(date.year, date.month, date.day)
            .subtract(date.timeZoneOffset));

    _firebaseAddData(
      'timeStampMarker',
      1,
      timeStamp,
      user,
      userData,
    );
  }

  void _sendMessage() async {
    final _copiedMessage = _enteredMessage.trim();
    setState(() {
      _enteredMessage = '';
    });
    if (_copiedMessage != '') {
      final user = await FirebaseAuth.instance.currentUser();
      final userData =
          await Firestore.instance.collection('users').document(user.uid).get();
      DocumentSnapshot sentUserData;
      if (widget.collection != 'chat')
        sentUserData = await Firestore.instance
            .collection('users')
            .document(widget.collection)
            .get();
      var lastMessage;
      if (widget.collection == 'chat')
        lastMessage = Firestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .limit(1);
      else
        lastMessage = Firestore.instance
            .collection(
                'chats/${widget.uid}/chat/${widget.collection}/messages')
            .orderBy('createdAt', descending: true)
            .limit(1);
      final snap = await lastMessage.getDocuments();
      int _count;
      if (snap.documents.length == 0) {
        _count = 1;
        _timeStampMarker(user, userData);
      } else {
        if (snap.documents[0]['text'] == 'timeStampMarker')
          _count = 1;
        else if (snap.documents[0]['userId'] == user.uid)
          _count = snap.documents[0]['count'] + 1;
        else
          _count = 1;
        final timeLast = snap.documents[0]['createdAt'];
        if (DateFormat.yMd().format(timeLast.toDate()) !=
            DateFormat.yMd().format(DateTime.now())) {
          _timeStampMarker(user, userData);
          _count = 1;
        }
      }

      _firebaseAddData(
        _copiedMessage,
        _count,
        Timestamp.now(),
        user,
        userData,
      );
      if (widget.collection != 'chat')
        _firebaseUpdateChat(
          user.uid,
          userData,
          widget.collection,
          sentUserData,
          _copiedMessage,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(const Radius.circular(30.0)),
                color: Theme.of(context).backgroundColor,
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    padding: const EdgeInsets.all(0.0),
                    // disabledColor: iconColor,
                    // color: iconColor,
                    icon: Icon(
                      Icons.insert_emoticon,
                      color: Theme.of(context).textTheme.bodyText2.color,
                    ),
                    onPressed: () {},
                  ),
                  Flexible(
                    child: TextField(
                      controller: _controller,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: _textInputAction,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(0.0),
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).textTheme.bodyText2.color,
                        ),
                        counterText: '',
                      ),
                      onEditingComplete: () {
                        if (_textInputAction == TextInputAction.send) {
                          _controller.clear();
                          if (_enteredMessage.isNotEmpty ||
                              _enteredMessage != null)
                            return _sendMessage();
                          else
                            return null;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          _enteredMessage = value.trim();
                        });
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      maxLength: 4096,
                      minLines: 1,
                    ),
                  ),
                  IconButton(
                    // color: iconColor,
                    icon: Icon(
                      Icons.attach_file,
                      color: Theme.of(context).textTheme.bodyText2.color,
                    ),
                    onPressed: () {},
                  ),
                  _enteredMessage.isEmpty || _enteredMessage == null
                      ? IconButton(
                          // color: iconColor,
                          icon: Icon(
                            Icons.camera_alt,
                            color: Theme.of(context).textTheme.bodyText2.color,
                          ),
                          onPressed: () {},
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Container(
              height: 50,
              width: 50,
              child: FittedBox(
                child: FloatingActionButton(
                  elevation: 2.0,
                  // backgroundColor: secondaryColor,
                  foregroundColor: Colors.white,
                  child: _enteredMessage.isEmpty || _enteredMessage == null
                      ? Icon(Icons.settings_voice)
                      : Icon(Icons.send),
                  onPressed: () {
                    _controller.clear();

                    if (_enteredMessage.isNotEmpty || _enteredMessage != null)
                      return _sendMessage();
                    else
                      return null;
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
