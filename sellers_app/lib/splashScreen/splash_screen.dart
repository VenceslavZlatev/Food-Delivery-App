import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/global/global.dart';
import 'package:flutter_application_1/mainScreens/home_screen.dart';

import 'authentication/auth_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      //is seller is already logged in
      if (firebaseAuth.currentUser != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      }
      //if seller is not logged in
      else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const AuthScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/splash.jpg"),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "Sell Food Online",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 40,
                      fontFamily: "Gilroy",
                      letterSpacing: 3),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
