import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_app/widget/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('created_add', descending: false)
            .snapshots(),
        builder: (ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitCircle(
              color: Colors.lightBlue,
            );
          }
          final docs = snapshot.data.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (ctx, index) {
              print(
                docs[index]['text'],
              );
              return ChatBubble(
                isMe: index % 2 == 0 ? false : true,
                message: docs[index]['text'],
                userName: docs[index]['user_name'],
                time: docs[index]['created_add'].toString(),
              );
            },
          );
        });
  }
}
