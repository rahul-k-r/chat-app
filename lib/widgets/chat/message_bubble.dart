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
    this.count,
    this.isGroup, {
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
  final bool isGroup;

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
              count: count,
              isGroup: isGroup,
            ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Bubble(
      margin: BubbleEdges.only(
        top: 10,
      ),
      alignment: Alignment.center,
      color: isDark
          ? Color.fromRGBO(212, 234, 244, 0.87)
          : Color.fromRGBO(212, 234, 244, 1.0),
      child: Text(
        _valueShown(),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11.0, color: Colors.grey[900]),
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
    @required this.isGroup,
  }) : super(key: key);

  final bool isMe;
  final double width;
  final String userName;
  final Timestamp createdAt;
  final String message;
  final String userImage;
  final bool count;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return Bubble(
      color: isMe
          ? Theme.of(context).backgroundColor
          : Theme.of(context).accentColor,
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
              if (isGroup)
                if (!count)
                  if (!isMe)
                    Text(
                      userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
              if (isGroup)
                if (!count)
                  SizedBox(
                    height: 5,
                  ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      message + '       \n',
                      maxLines: 50,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isMe
                            ? Theme.of(context).textTheme.bodyText2.color
                            : Theme.of(context).textTheme.bodyText1.color,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  // SizedBox(
                  //   width: width / 2.5,
                  // )
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  DateFormat.Hm().format(createdAt.toDate()),
                  style: TextStyle(
                    color: isMe
                        ? Theme.of(context).textTheme.bodyText2.color
                        : Theme.of(context).textTheme.bodyText1.color,
                    fontSize: 10,
                  ),
                  softWrap: true,
                ),
                // Align(
                //   alignment: Alignment.topCenter,
                //   child: Icon(
                //     Icons.check,
                //     color: isMe
                //         ? Colors.black
                //         : Theme.of(context).textTheme.bodyText2.color,
                //     size: 12,
                //   ),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}
