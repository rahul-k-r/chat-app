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
    this.width,
    this.count, {
    this.key,
  });

  final Key key;
  final String message;
  final String userName;
  final String userImage;
  final createdAt;
  final double width;
  final bool isMe;
  final bool count;

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
              userImage: userImage,
              count: count),
    );
  }
}

class TimeStampDenoter extends StatelessWidget {
  TimeStampDenoter(this._timenow);

  final DateTime _timenow;

  int _timeCompare() {
    int days = DateTime.now().difference(_timenow).inDays;
    if (days > 1)
      return -1;
    else
      return days;
  }

  String _valueShown() {
    final _comparison = _timeCompare();
    if (_comparison == -1)
      return DateFormat.yMMMMd().format(_timenow);
    else if (_comparison == 1)
      return 'YESTERDAY';
    else
      return 'TODAY';
  }

  @override
  Widget build(BuildContext context) {
    return Bubble(
      margin: BubbleEdges.only(
        top: 10,
      ),
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
    @required this.count,
  }) : super(key: key);

  final bool isMe;
  final double width;
  final String userName;
  final Timestamp createdAt;
  final String message;
  final String userImage;
  final bool count;

  @override
  Widget build(BuildContext context) {
    return Bubble(
      color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      nip: count ? BubbleNip.no : isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
      margin: isMe
          ? BubbleEdges.only(top: count ? 3 : 10, left: width)
          : BubbleEdges.only(top: count ? 2 : 10, right: width),
      elevation: 1,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!count)
                if (!isMe)
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline6.color,
                    ),
                  ),
              if (!count)
                SizedBox(
                  height: 5,
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      message + '      ',
                      maxLines: 50,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isMe
                            ? Colors.black
                            : Theme.of(context).accentTextTheme.headline6.color,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    width: width / 10,
                  )
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Text(
              DateFormat.Hm().format(createdAt.toDate()),
              style: TextStyle(
                color: isMe
                    ? Colors.black
                    : Theme.of(context).accentTextTheme.headline6.color,
                fontSize: 10,
              ),
              softWrap: true,
            ),
          )
        ],
      ),
    );
  }
}
