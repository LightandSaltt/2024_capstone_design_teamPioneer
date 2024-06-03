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
  final _gradeController = TextEditingController();

  String? _selectedDepartment;
  String? _selectedMajor;

  final Map<String, List<String>> _departments = {
    '문과대학': ['국어국문・창작학과', '영어영문학과', '응용영어콘텐츠학과', '일어일문학전공', '프랑스어문학전공', '문헌정보학과', '사학과', '기독교학과'],
    '사범대학': ['국어교육과', '영어교육과', '교육학과', '역사교육과', '미술교육과', '수학교육과'],
    '공과대학': ['정보통신학과', '전기전자공학과', '멀티미디어공학과', '건축학과', '건축공학전공', '토목환경공학전공', '기계공학과', '화학공학과', '신소재공학과'],
    '스마트융합대학': ['컴퓨터공학과', '산업경영공학과', 'AI융합학과', '수학과', '빅데이터응용학과'],
    '경상대학': ['경영학과', '회계학과', '무역물류학과', '경제학과', '중국경제통상학과', '호텔항공경영학과', '경영정보학과'],
    '사회과학대학': ['법학전공', '법무법학전공', '행정학과', '경찰학과', '정치언론학과', '사회복지학과', '아동복지학과', '상담심리학과', '사회적경제기업학과'],
    '생명・나노과학대학': ['생명시스템과학과', '식품영양학과', '화학과', '간호학과', '스포츠과학과', '바이오제약공학과', '융합기술경영학과'],
    '탈메이지교양・융합대학': ['창의융합학부', '자유전공학부'],
    '아트・디자인테크놀로지대학': ['회화과', '미디어영상학과', '패션디자인학과', '융합디자인학과'],
    '린튼글로벌스쿨': ['글로벌IT경영전공', '글로벌비즈니스전공'],
    '교수 및 교직원': ['교수', '교직원']
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('학생 정보 입력')),
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
                  decoration: const InputDecoration(labelText: '이름'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return '이름을 입력하세요.';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _studentIdController,
                  decoration: const InputDecoration(labelText: '학번'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return '학번을 입력하세요.';
                    if (!RegExp(r'^\d{8}$').hasMatch(value)) return '올바른 학번 8자리를 입력해주세요.';
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedDepartment,
                  decoration: const InputDecoration(labelText: '학부'),
                  items: _departments.keys.map((String department) {
                    return DropdownMenuItem<String>(value: department, child: Text(department));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDepartment = newValue;
                      _selectedMajor = null;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) return '학부를 선택하세요.';
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedMajor,
                  decoration: const InputDecoration(labelText: '학과'),
                  items: _selectedDepartment != null
                      ? _departments[_selectedDepartment]!.map((String major) {
                    return DropdownMenuItem<String>(value: major, child: Text(major));
                  }).toList()
                      : [],
                  onChanged: (String? newValue) => setState(() => _selectedMajor = newValue),
                  validator: (value) {
                    if (value == null || value.isEmpty) return '학과를 선택하세요.';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _gradeController,
                  decoration: const InputDecoration(labelText: '학년'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return '학년을 입력하세요.';
                    if (int.tryParse(value) == null || int.parse(value) <= 0 || int.parse(value) > 5) {
                      return '1~4 사이의 숫자를 입력하세요.';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0, top: 16.0),
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF32810D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                final databaseRef = FirebaseDatabase.instance.ref();
                                await databaseRef.child('users/${user.uid}').set({
                                  'name': _nameController.text,
                                  'studentId': _studentIdController.text,
                                  'department': _selectedDepartment,
                                  'major': _selectedMajor,
                                  'grade': _gradeController.text,
                                });

                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HansikMainPage()));
                              }
                            } catch (e) {
                              print("Error saving user data: $e");
                            }
                          }
                        },
                        child: const Text(
                          '저장하기',
                          style: TextStyle(fontSize: 18), // 폰트 크기 설정 (원하는 크기로 변경)
                        ),
                      ),
                    ),
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
