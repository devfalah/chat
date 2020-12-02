import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  TextEditingController _controller = TextEditingController();
  OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: Colors.transparent));
  String message = "";
  _sendMessage() async {
    try {
      final User user = FirebaseAuth.instance.currentUser;

      final userName = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      FocusScope.of(context).unfocus();
      await FirebaseFirestore.instance.collection('chat').add(
        {
          'text': message,
          'created_add': Timestamp.now(),
          'user_name': userName['user_name'],
          'userId': user.uid,
          "user_image": userName['image_url'],
        },
      );
    } catch (e) {
      print(e);
    }

    _controller.clear();
    setState(() {
      message = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff0C0C14),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: 150.0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      child: Row(
        children: <Widget>[
          Container(
            child: IconButton(
              icon: Icon(Icons.insert_emoticon),
              color: Colors.white,
              onPressed: () {},
            ),
          ),
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: _controller,
              keyboardType: TextInputType.multiline,
              autofocus: false,
              decoration: InputDecoration(
                  hintText: 'Please enter the message',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  enabledBorder: border,
                  disabledBorder: border,
                  border: border,
                  errorBorder: border,
                  focusedErrorBorder: border,
                  focusedBorder: border),
              onChanged: (v) {
                message = v;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            child: RawMaterialButton(
              onPressed: _sendMessage,
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
              fillColor: Color(0xffFB5A34),
              shape: CircleBorder(),
              elevation: 0.0,
            ),
            constraints: BoxConstraints(
              maxWidth: 40,
              maxHeight: 40,
            ),
          )
        ],
      ),
    );
  }
}
