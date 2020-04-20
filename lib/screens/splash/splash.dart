import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uslabs_assignment/screens/home/home.dart';
import 'package:uslabs_assignment/screens/main/profile.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  initState() {
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {
              if (currentUser == null)
                {
                  Future.delayed(Duration(seconds: 3))
                      .then((onValue) =>
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Home())))
                      .catchError((onError) {})
                }
              else
                {
                  Firestore.instance
                      .collection("users")
                      .document(currentUser.uid)
                      .get()
                      .then((DocumentSnapshot result) => Future.delayed(
                              Duration(seconds: 3))
                          .then((onValue) =>
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen(documentSnapshot: result,))))
                          .catchError((onError) {}))
                      .catchError((err) => print(err))
                }
            })
        .catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error,
              color: Colors.white,
              size: 80,
            ),
            Text(
              "Splash Screen",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 50),
            ),
            SizedBox(height: 30),
            Center(child: CircularProgressIndicator( backgroundColor: Colors.white,))
          ],
        ),
      ),
    );
  }
}


 