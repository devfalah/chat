import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/screens/chat.dart';
import 'package:firebase_app/widget/auth_form.dart';
import 'package:firebase_app/widget/user_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

enum AuthType {
  login,
  register,
}

class AuthScreen extends StatefulWidget {
  AuthType authType;

  AuthScreen({
    this.authType = AuthType.register,
  });

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  File _userPickedImage;
  void _pickedImage(File pickedImage) {
    _userPickedImage = pickedImage;
  }

  Future<void> _submitAuthForm({
    String email,
    String password,
    String userName,
    AuthType authType,
    BuildContext context,
    File image,
  }) async {
    UserCredential userCredential;
    String message;
    try {
      setState(() {
        _isLoading = true;
      });
      if (authType == AuthType.login) {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else if (authType == AuthType.register) {
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(userCredential.user.uid + 'jpg');
        await ref.putFile(image);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('user')
            .doc(userCredential.user.uid)
            .set({
          'user_name': userName,
          'password': password,
          "image_url": url,
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
        ),
        backgroundColor: Colors.red,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Color(0xffFB5A34),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(70),
                      bottomRight: Radius.circular(70),
                    ),
                  ),
                ),
                if (widget.authType == AuthType.login)
                  Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      TextLiquidFill(
                        text: 'Hello!',
                        waveColor: Colors.white,
                        boxBackgroundColor: Color(0xffFB5A34),
                        textStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        boxHeight: 60.0,
                      ),
                      Image.asset('assets/images/logo.png'),
                    ],
                  ),
                if (widget.authType == AuthType.register)
                  UserImagePicker(_pickedImage),
              ],
            ),
            AuthForm(
                widget.authType, _submitAuthForm, _isLoading, _userPickedImage),
          ],
        ),
      ),
    );
  }
}
