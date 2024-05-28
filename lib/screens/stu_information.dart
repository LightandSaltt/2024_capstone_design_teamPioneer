import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'hansik_main_page.dart';

class StuInformation extends StatefulWidget {
  @override
  _StuInformationState createState() => _StuInformationState();
}

class _StuInformationState extends State<StuInformation> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _majorController = TextEditingController();
  final _gradeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('학생 정보 입력'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: '이름'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이름을 입력하세요.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _studentIdController,
                  decoration: InputDecoration(labelText: '학번'),
                  keyboardType: TextInputType.number, // 숫자 키보드
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '학번을 입력하세요.';
                    }
                    // 학번 형식에 맞는지 확인하는 추가적인 유효성 검사 로직을 여기에 추가할 수 있습니다.
                    return null;
                  },
                ),
                TextFormField(
                  controller: _majorController,
                  decoration: InputDecoration(labelText: '전공'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '전공을 입력하세요.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _gradeController,
                  decoration: InputDecoration(labelText: '학년'),
                  keyboardType: TextInputType.number, // 숫자 키보드
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '학년을 입력하세요.';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0 || int.parse(value) > 5) {
                      return '1~4 사이의숫자를 입력하세요.';
                    }
                    return null;
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            final databaseRef = FirebaseDatabase.instance.ref();
                            await databaseRef.child('users/${user.uid}').set({
                              'name': _nameController.text,
                              'studentId': _studentIdController.text,
                              'major': _majorController.text,
                              'grade': _gradeController.text,
                            });

                            // 정보 입력 후 HansikMainPage로 이동
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HansikMainPage()),
                            );
                          }
                        } catch (e) {
                          print("Error saving user data: $e");
                          // 오류 처리 (예: 사용자에게 오류 메시지 표시)
                        }
                      }
                    },
                    child: Text('저장'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
