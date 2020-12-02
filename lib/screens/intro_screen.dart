import 'package:firebase_app/screens/auth_screen.dart';
import 'package:firebase_app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(),
            Image.asset('assets/images/logo.png'),
            Button(
                text: "Get Started",
                color: Colors.white,
                textColor: Colors.lightBlue,
                onPressed: () async {
                  // SharedPreferences pref =
                  //     await SharedPreferences.getInstance();
                  // pref.setBool("first", true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthScreen(
                        authType: AuthType.register,
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
