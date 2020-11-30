import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/widget/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthType {
  login,
  register,
}

class AuthScreen extends StatefulWidget {
  final AuthType authType;

  AuthScreen({
    this.authType,
  });

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  Future<void> loginRegister({
    String email,
    String password,
    String userName,
    AuthType authType,
    BuildContext context,
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
      } else {
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('user')
            .doc(userCredential.user.uid)
            .set({
          'user_name': userName,
          'password': password,
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
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(70),
                      bottomRight: Radius.circular(70),
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    TextLiquidFill(
                      text: 'Hello!',
                      waveColor: Colors.white,
                      boxBackgroundColor: Colors.lightBlue,
                      textStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      boxHeight: 60.0,
                    ),
                    Image.asset('assets/images/logo.png'),
                  ],
                ),
              ],
            ),
            AuthForm(widget.authType, loginRegister, _isLoading),
          ],
        ),
      ),
    );
  }
}
