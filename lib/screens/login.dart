import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

import 'package:firebase_database/firebase_database.dart'; // Firebase Realtime Database 추가
import 'stu_information.dart'; // 사용자 정보 입력 페이지 임포트
import 'hansik_main_page.dart'; // 메인 페이지 임포트

import 'mypage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class _LoginScreenState extends State<LoginScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        // 사용자가 로그인되어 있으면 Firebase Realtime Database에서 정보 확인
        DatabaseReference ref = FirebaseDatabase.instance.ref();
        final snapshot = await ref.child('users/${user.uid}').get();
        if (snapshot.exists) {
          // 정보가 존재하면 메인 페이지로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HansikMainPage()),
          );
        } else {
          // 정보가 없으면 사용자 정보 입력 페이지로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StuInformation()),
          );
        }
      }
    });
  }

  void _handleGoogleSignIn() {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }

  Widget _googleSignInButton() { // 위젯 함수로 변경
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.google,
          text: "Sign in with Google",
          onPressed: _handleGoogleSignIn,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 120),
              TextHeader(),
              SizedBox(height: 100),
              _googleSignInButton(),
              SizedBox(height: 150),
              BottomImage(),
            ],
          ),
        ),
      ),
    );
  }
}

class TextHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Text(
              'Hansik',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF32810D),
              ),
            ),
            SizedBox(width: 10),
            Image.asset('assets/hansik_logo.png', height: 28),
          ],
        ),
        SizedBox(height: 120),
        Text(
          'Hannam Univ',
          style: TextStyle(
            fontSize: 38,
            color: Color(0xFF10296C),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '한남대학교 구글 이메일로 로그인 해주세요. 예)20191485@gm.hannam.ac.kr',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class BottomImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/hannam_logo.png', height: 80);
  }
}
