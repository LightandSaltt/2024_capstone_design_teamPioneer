import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/student.dart'; // Student 클래스 import
import 'hansik_main_page.dart';

class StuInformation extends StatefulWidget {
  const StuInformation({Key? key}) : super(key: key);

  @override
  _StuInformationState createState() => _StuInformationState();
}

class _StuInformationState extends State<StuInformation> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _majorController = TextEditingController();
  int _grade = 1;
  int _semester = 1;

  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  void dispose() {
    // 텍스트 컨트롤러 dispose
    _nameController.dispose();
    _studentIdController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final student = Student(
          name: _nameController.text,
          studentId: _studentIdController.text,
          major: _majorController.text,
          grade: _grade,
          semester: _semester,
        );

        try {
          await databaseReference.child('users/${user.uid}').set(student.toMap());

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HansikMainPage()),
          );
        } catch (error) {
          print('Error saving user data: $error');
          // 사용자에게 에러 메시지 표시 (showDialog 등)
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Hansik',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF32810D),
              ),
            ),
            SizedBox(width: 10),
            Image.asset('assets/hansik_logo.png', height: 28),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset('assets/user_sample.png', height: 100),
                SizedBox(height: 30),
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
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '학번을 입력하세요.';
                    }
                    // 학번 유효성 검사 로직 (20000000 ~ 29999999)
                    return null;
                  },
                ),
                TextFormField(
                  controller: _majorController,
                  decoration: InputDecoration(labelText: '학과'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '학과를 입력하세요.';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<int>(
                  value: _grade,
                  items: List.generate(4, (index) => index + 1)
                      .map((grade) => DropdownMenuItem(
                    value: grade,
                    child: Text('$grade학년'),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _grade = value!),
                  decoration: InputDecoration(labelText: '학년'),
                ),
                DropdownButtonFormField<int>(
                  value: _semester,
                  items: [1, 2].map((semester) => DropdownMenuItem(
                    value: semester,
                    child: Text('$semester학기'),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _semester = value!),
                  decoration: InputDecoration(labelText: '학기'),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF32810D),
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: _submitForm,
                  child: Text('회원 가입 하기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
