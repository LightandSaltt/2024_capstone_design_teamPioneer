import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'menu_screen.dart';
import 'login.dart';
import 'stu_information.dart'; // 학생 정보 입력 페이지 import 추가

class HansikMainPage extends StatefulWidget {
  @override
  _HansikMainPageState createState() => _HansikMainPageState();
}

class _HansikMainPageState extends State<HansikMainPage> {
  String? name;
  String? studentId;
  String? major;
  String? grade;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final databaseRef = FirebaseDatabase.instance.ref();
        final snapshot = await databaseRef.child('users/${user.uid}').get();

        if (snapshot.exists) {
          final userData = snapshot.value as Map<dynamic, dynamic>;
          setState(() {
            name = userData['name'] as String?; // Firebase에서 가져온 이름 사용
            studentId = userData['studentId'] as String?;
            major = userData['major'] as String?;
            grade = userData['grade'] as String?;
          });
        } else {
          // 사용자 정보가 없는 경우 정보 입력 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StuInformation()),
          );
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
      // 오류 처리 (예: 사용자에게 오류 메시지 표시)
    }
  }

  List<String> _menuItems = [
    '된장국', '현미밥', '된장찌개', '제육볶음', '볶음김치', '플레인 요구르트',
  ];

  Widget customButton(String iconPath, String label, BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (label == '메뉴') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuScreen()),
          );
        }
      },
      child: Container(
        width: 80,
        child: Column(
          children: <Widget>[
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F9F4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), // 텍스트 스타일
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: SvgPicture.asset('assets/ic_alarm.svg'),
              onPressed: () {
                // 알림 로직 처리
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20, left: 40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 24,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: '오늘의 식사도\n'),
                      TextSpan(
                        text: 'Hansik',
                        style: TextStyle(color: Color(0xFF32810D)),
                      ),
                      TextSpan(text: '과 함께'),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23, right: 23),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F9F4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/ic_university.png',
                                width: 58,
                                height: 58,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(name ?? "사용자", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(studentId ?? "", style: TextStyle(fontSize: 12)),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 7),
                                Text("$major $grade" ?? "", style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
                padding: const EdgeInsets.only(left: 23, right: 23),
                child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFDDEED5),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/ic_pay.svg',
                                    width: 84,
                                    height: 20,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    )
                )

            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  customButton('assets/ic_buy.svg', '식권구매', context),
                  customButton('assets/ic_tickets.svg', '식권함', context),
                  customButton('assets/ic_menu.svg', '메뉴', context),
                  customButton('assets/ic_homepage.svg', '홈페이지', context),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 15, left: 20, bottom: 30, right: 20),
                color: const Color(0xFFF4F4F4),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                        const Text("멘사 점심메뉴", style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text("2024.03.26", style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: (_menuItems.length * 29) + 30.0,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: SvgPicture.asset('assets/bg_btn_left.svg'),
                                onPressed: () {
                                  // 이전 날짜로 변경
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15, bottom: 15),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 200,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: _menuItems.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(vertical: 2),
                                        child: Text(
                                          _menuItems[index],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              IconButton(
                                icon: SvgPicture.asset('assets/bg_btn_right.svg'),
                                onPressed: () {
                                  // 다음 날짜로 변경
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}