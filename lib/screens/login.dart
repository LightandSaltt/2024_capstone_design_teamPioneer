import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'hansik_main_page.dart';
import 'stu_information.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;

        // 사용자 정보 변경 감지 시 로그인 여부 확인 후 페이지 이동
        if (_user != null) {
          _checkUserInDatabase();
        }
      });
    });
  }

  Future<void> _checkUserInDatabase() async {
    final userRef = _database.child('users').child(_user!.uid);
    final snapshot = await userRef.get();
    if (snapshot.value == null) {
      // 사용자 정보가 데이터베이스에 없음
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StuInformation()),
      );
    } else {
      // 사용자 정보가 데이터베이스에 있음
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HansikMainPage()),
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // 사용자가 로그인 취소
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      if (_user != null) {
        _checkUserInDatabase();
      }
    } catch (error) {
      print(error);
    }
  }

  Widget _googleSignInButton() {
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
