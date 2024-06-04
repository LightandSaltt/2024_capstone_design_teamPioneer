import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'hansik_main_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;

        // 사용자 정보 변경 감지 시 로그인 여부 확인 후 페이지 이동
        if (_user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HansikMainPage()),
          );
        }
      });
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
            Image.asset('assets/images/hansik_logo.png', height: 28),
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
    return Image.asset('assets/images/hannam_logo.png', height: 80);
  }
}