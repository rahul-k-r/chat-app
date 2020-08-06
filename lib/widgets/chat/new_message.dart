import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewMessage extends StatefulWidget {
  final collection;
  final uid;
  NewMessage(this.uid, this.collection);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextInputAction _textInputAction = TextInputAction.send;
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  void _firebaseAddData(
    String _copiedMessage,
    int _count,
    Timestamp createdAt,
    FirebaseUser user,
    DocumentSnapshot userData,
  ) async {
    var id1 = 'chats/${widget.collection}/chat/${widget.uid}/messages';
    var id2 = 'chats/${widget.uid}/chat/${widget.collection}/messages';

    var _message;
    if (widget.collection == 'chat')
      _message = await Firestore.instance.collection('chat').add({
        'text': _copiedMessage.trim(),
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
        'text': _copiedMessage.trim(),
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
        'text': _copiedMessage.trim(),
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
    print(_message.documentID);
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
    final _copiedMessage = _enteredMessage;
    setState(() {
      _enteredMessage = '';
    });
    if (_copiedMessage != '') {
      final user = await FirebaseAuth.instance.currentUser();
      final userData =
          await Firestore.instance.collection('users').document(user.uid).get();
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
        }
      }

      _firebaseAddData(
        _copiedMessage,
        _count,
        Timestamp.now(),
        user,
        userData,
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
                color: Colors.white,
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    padding: const EdgeInsets.all(0.0),
                    // disabledColor: iconColor,
                    // color: iconColor,
                    icon: Icon(Icons.insert_emoticon),
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
                          // color: textFieldHintColor,
                          fontSize: 16.0,
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
                    icon: Icon(Icons.attach_file),
                    onPressed: () {},
                  ),
                  _enteredMessage.isEmpty || _enteredMessage == null
                      ? IconButton(
                          // color: iconColor,
                          icon: Icon(Icons.camera_alt),
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
