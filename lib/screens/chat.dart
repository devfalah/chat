import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_app/widget/message.dart';
import 'package:firebase_app/widget/chat_input.dart';

class ChatingScreen extends StatefulWidget {
  @override
  _ChatingScreenState createState() => _ChatingScreenState();
}

class _ChatingScreenState extends State<ChatingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0C0C14),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  constraints: BoxConstraints(
                    maxWidth: 40,
                    maxHeight: 40,
                  ),
                  elevation: 1,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        backgroundColor: Color(0xff0C0C14),
                        title: Text(
                          'Sign Out?',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        content: Text(
                          'This will sign Out.',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        actions: [
                          FlatButton(
                            textColor: Color(0xffFB5A34),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('CANCEL'),
                          ),
                          FlatButton(
                            textColor: Color(0xffFB5A34),
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).pop();
                            },
                            child: Text('ACCEPT'),
                          ),
                        ],
                      ),
                    );
                  },
                  fillColor: Colors.transparent,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  constraints: BoxConstraints(
                    maxWidth: 40,
                    maxHeight: 40,
                  ),
                  elevation: 1,
                  child: Icon(
                    Icons.delete,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        backgroundColor: Color(0xff0C0C14),
                        title: Text(
                          'Delete All?',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        content: Text(
                          'This will Delete All.',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        actions: [
                          FlatButton(
                            textColor: Color(0xffFB5A34),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('CANCEL'),
                          ),
                          FlatButton(
                            textColor: Color(0xffFB5A34),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('chat')
                                  .get()
                                  .then((snapshot) {
                                for (DocumentSnapshot ds in snapshot.docs) {
                                  ds.reference.delete();
                                }
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(child: Messages()),
          ChatInput(),
        ],
      ),
    );
  }
}
