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
  double _imageHeightFactor = 0.6; // 초기 이미지 높이 (화면 높이의 비율)

  // 프로그램적으로 이미지 크기를 조절하는 메서드
  void adjustImageSize(double factor) {
    setState(() {
      _imageHeightFactor = factor;
    });
  }

  @override
  void initState() {
    super.initState();
    // 여기서 이미지 크기를 프로그램적으로 조절
    adjustImageSize(0.8); // 예: 이미지 높이를 화면 높이의 80%로 설정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR 사용 전 비밀번호 확인"),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey.withOpacity(0.2), // 반투명 회색 배경 설정
          ),
          Align(
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset(0.0, -50.0), // 이미지 Y축 위치를 위로 올림
              child: OverflowBox(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height,
                child: Image.asset(
                  'assets/images/chef.png', // 업데이트된 이미지 파일 경로
                  height: MediaQuery.of(context).size.height * _imageHeightFactor, // 조절된 높이
                  width: MediaQuery.of(context).size.width, // 조절된 너비
                  fit: BoxFit.contain, // BoxFit을 contain으로 변경
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    await _authenticateWithBiometrics();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow, // 노른자 부분 색상
                    side: BorderSide(color: Colors.white, width: 6), // 흰자 부분 테두리
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    shadowColor: Colors.black,
                    elevation: 10,
                  ),
                  child: Text(
                    "지문 인증",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _showPasswordDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow, // 노른자 부분 색상
                    side: BorderSide(color: Colors.white, width: 6), // 흰자 부분 테두리
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    shadowColor: Colors.black,
                    elevation: 10,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "비밀번호로 인증",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
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
