import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({this.message, this.time, this.isMe, this.userName});

  final String message, time, userName;
  final isMe;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.white : Colors.lightBlue.shade100;
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
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 48.0),
                child: Text(
                  message,
                  style: TextStyle(
                    color: isMe ? Colors.black : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
