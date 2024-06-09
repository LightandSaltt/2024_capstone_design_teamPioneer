import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hansik_app/screens/qr_pay.dart';
import 'package:local_auth/local_auth.dart';

class PasswordCheck extends StatefulWidget {
  @override
  _PasswordCheckState createState() => _PasswordCheckState();
}

class _PasswordCheckState extends State<PasswordCheck> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isLoading = false;

  // 이미지 위치 조절 변수
  final double _imagePositionX = 0.0; // 원하는 X 위치 값
  final double _imagePositionY = 0.0; // 원하는 Y 위치 값

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR 사용 전 비밀번호 확인"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Container(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: Offset(_imagePositionX, _imagePositionY),
                child: Image.asset(
                  'assets/images/chef.png',
                  height: 600, width: 350,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _isLoading ? null : () async {
                await _authenticateWithBiometrics();
              },
              child: Text("지문 인증"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _showPasswordDialog,
              child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text("비밀번호로 인증"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showPasswordDialog() {
    final TextEditingController passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("비밀번호 입력"),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "비밀번호",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("확인"),
              onPressed: () {
                _checkPassword(passwordController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _checkPassword(String password) async {
    setState(() {
      _isLoading = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user.uid}');
      DataSnapshot snapshot = await ref.child('password').get();
      if (snapshot.exists && snapshot.value == password) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QrPay()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("비밀번호가 잘못되었습니다."))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("로그인 상태가 아닙니다."))
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: '지문을 사용하여 인증하세요',
        options: AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      print('Error using biometric authentication: $e');
    }

    if (authenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QrPay()),
      );
    }
  }
}
