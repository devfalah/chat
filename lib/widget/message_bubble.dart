import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message, userName, image;
  final isMe;
  final Key key;

  ChatBubble({this.key, this.message, this.userName, this.isMe, this.image});

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Color(0xffFB5A34) : Color(0xff15151B);
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          width: 140,
          margin: const EdgeInsets.all(9.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: isMe
                      ? Colors.black.withOpacity(.4)
                      : Color(0xffFB5A34).withOpacity(.4))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 48.0),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: isMe ? Alignment.topLeft : Alignment.topRight,
                      child: Text(
                        userName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        textAlign: isMe ? TextAlign.end : TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment:
                          isMe ? Alignment.bottomLeft : Alignment.bottomRight,
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: isMe ? TextAlign.end : TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -20,
                left: isMe ? 110 : null,
                right: isMe ? null : 110,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(image),
                ),
              )
            ],
            overflow: Overflow.visible,
          ),
        )
      ],
    );
  }
}
