import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
    this.message,
    this.userName,
    this.userImage,
    this.isMe,
    this.createdAt,
    this.width, {
    this.key,
  });

  final Key key;
  final String message;
  final String userName;
  final String userImage;
  final createdAt;
  final double width;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: message == 'timeStampMarker'
          ? TimeStampDenoter(createdAt.toDate())
          : MessageStack(
              isMe: isMe,
              width: width,
              userName: userName,
              createdAt: createdAt,
              message: message,
              userImage: userImage),
    );
  }
}

class TimeStampDenoter extends StatelessWidget {
  TimeStampDenoter(this._timenow);

  final DateTime _timenow;

  int _timeCompare() {
    if (DateFormat.yM().format(_timenow) !=
        DateFormat.yM().format(DateTime.now()))
      return -1;
    else
      return int.parse(DateFormat.d().format(DateTime.now())) -
          int.parse(DateFormat.d().format(_timenow));
  }

  String _valueShown() {
    final _comparison = _timeCompare();
    if (_comparison == -1 || _comparison > 2)
      return DateFormat.MMMMd().format(_timenow);
    else if (_comparison == 1)
      return 'YESTERDAY';
    else
      return 'TODAY';
  }

  @override
  Widget build(BuildContext context) {
    return Bubble(
      alignment: Alignment.center,
      color: Color.fromRGBO(212, 234, 244, 1.0),
      child: Text(
        _valueShown(),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11.0),
      ),
    );
  }
}

class MessageStack extends StatelessWidget {
  const MessageStack({
    Key key,
    @required this.isMe,
    @required this.width,
    @required this.userName,
    @required this.createdAt,
    @required this.message,
    @required this.userImage,
  }) : super(key: key);

  final bool isMe;
  final double width;
  final String userName;
  final Timestamp createdAt;
  final String message;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Bubble(
          color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
          alignment: isMe ? Alignment.topRight : Alignment.topLeft,
          nip: isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
          margin: isMe
              ? BubbleEdges.only(top: 10, left: width)
              : BubbleEdges.only(top: 10, right: width),
          elevation: 1,
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isMe
                      ? Colors.black
                      : Theme.of(context).accentTextTheme.headline6.color,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  isMe
                      ? Text(
                          DateFormat.Hm().format(createdAt.toDate()),
                          style: TextStyle(
                            color: isMe
                                ? Colors.black
                                : Theme.of(context)
                                    .accentTextTheme
                                    .headline6
                                    .color,
                            fontSize: 10,
                          ),
                        )
                      : Container(),
                  isMe ? Spacer() : Container(),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline6.color,
                    ),
                  ),
                  !isMe ? Spacer() : Container(),
                  !isMe
                      ? Text(
                          DateFormat.Hm().format(createdAt.toDate()),
                          style: TextStyle(
                            color: isMe
                                ? Colors.black
                                : Theme.of(context)
                                    .accentTextTheme
                                    .headline6
                                    .color,
                            fontSize: 10,
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 3,
          left: isMe ? null : 2 * width,
          right: isMe ? width * 2 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              userImage,
            ),
            radius: 15,
          ),
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
