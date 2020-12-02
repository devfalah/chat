import 'dart:io';

import 'package:firebase_app/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_app/screens/chat.dart';

import 'button.dart';

class AuthForm extends StatefulWidget {
  final AuthType authType;
  final Function submit;
  final bool isLoading;
  final File _userPickedImage;

  AuthForm(this.authType, this.submit, this.isLoading, this._userPickedImage);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  String _userName = "";
  var border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey[200],
    ),
    borderRadius: BorderRadius.circular(25),
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                enabledBorder: border,
                disabledBorder: border,
                border: border,
                errorBorder: border,
                focusedErrorBorder: border,
                focusedBorder: border,
                labelText: "Enter your email",
              ),
              validator: (value) =>
                  value.isEmpty ? "Please Enter a valid email" : null,
              onChanged: (value) {
                _email = value;
              },
            ),
            SizedBox(
              height: 12,
            ),
            if (widget.authType == AuthType.register)
              TextFormField(
                decoration: InputDecoration(
                  enabledBorder: border,
                  disabledBorder: border,
                  border: border,
                  errorBorder: border,
                  focusedErrorBorder: border,
                  focusedBorder: border,
                  labelText: "User name",
                ),
                onChanged: (value) => _userName = value,
                validator: (value) =>
                    value.isEmpty ? "Please enter your username" : null,
              ),
            SizedBox(
              height: 12,
            ),
            TextFormField(
              decoration: InputDecoration(
                enabledBorder: border,
                disabledBorder: border,
                border: border,
                errorBorder: border,
                focusedErrorBorder: border,
                focusedBorder: border,
                labelText: "Enter your password",
              ),
              obscureText: true,
              validator: (value) =>
                  value.length < 6 ? "Your password is short" : null,
              onChanged: (value) => _password = value,
            ),
            SizedBox(
              height: 20,
            ),
            if (widget.isLoading)
              SpinKitThreeBounce(
                color: Color(0xffFB5A34),
              ),
            if (!widget.isLoading)
              Button(
                  text:
                      widget.authType == AuthType.login ? "Login" : "Register",
                  color: Color(0xffFB5A34),
                  textColor: Colors.white,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      FocusScope.of(context).unfocus();
                      if (widget.authType == AuthType.register) if (widget
                              ._userPickedImage ==
                          null) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Please pick an image",
                          ),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }
                      setState(() {});
                      await widget.submit(
                        email: _email.trim(),
                        password: _password,
                        userName: _userName,
                        authType: widget.authType,
                        context: context,
                        image: widget._userPickedImage,
                      );
                    }
                  }),
            SizedBox(
              height: 10,
            ),
            if (!widget.isLoading)
              FlatButton(
                child: Text(
                  widget.authType == AuthType.login
                      ? "Don\'t have an account?"
                      : "You have an account?",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  if (widget.authType == AuthType.login) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthScreen(
                          authType: AuthType.register,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthScreen(
                          authType: AuthType.login,
                        ),
                      ),
                    );
                  }
                },
              )
          ],
        ),
      ),
    );
  }
}
