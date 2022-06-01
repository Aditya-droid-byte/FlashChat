import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Verification extends StatefulWidget {
  static const String id = 'verification_screen';
  const Verification({Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;

  @override
  void initState() {
    user = auth.currentUser!;
    user?.sendEmailVerification();
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmailVerification();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'FLASH CHAT',
          style: TextStyle(),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Card(
            margin: EdgeInsets.fromLTRB(60.0, 200.0, 60.0, 250.0),
            color: Colors.black,
            shadowColor: Colors.redAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'An E-mail has been sent to ${user!.email}',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'PLEASE VERiFY YOUR E-MAIL',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'CHECK YOUR SPAM BOX',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Future<void> checkEmailVerification() async {
    user = auth.currentUser!;
    await user?.reload();
    if (user!.emailVerified) {
      timer?.cancel();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChatScreen()));
    }
  }
}
