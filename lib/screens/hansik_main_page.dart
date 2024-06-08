import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hansik_app/screens/qr_pay.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'buy_ticket.dart';
import 'menu_screen.dart';
import 'hnu_map.dart';
import 'login.dart';
import 'mypage.dart';
import 'stu_information.dart';

class HansikMainPage extends StatefulWidget {
  @override
  _HansikMainPageState createState() => _HansikMainPageState();
}

class PageInfo {
  final String iconPath;
  final String label;
  final Widget? page;
  final String? url;

  PageInfo(this.iconPath, this.label, {this.page, this.url});
}

final List<PageInfo> _pageInfos = [
  PageInfo('assets/images/ic_buy.svg', '식권구매', page: BuyTicket()),
  PageInfo('assets/images/marker_icon.svg', '학교맵', page: HnuMap()),
  PageInfo('assets/images/ic_menu.svg', '메뉴', page: MenuScreen()), // 메뉴 스크린 페이지 유지
  PageInfo('assets/images/ic_homepage.svg', '홈페이지', url: 'https://www.hannam.ac.kr/kor/main/'),
];

class _HansikMainPageState extends State<HansikMainPage> {
  String? name;
  String? studentId;
  String? major;
  String? grade;
  DateTime currentDate = DateTime.now();

  List<MenuItem> menuList = [
    MenuItem(
      date: "2024-06-05",
      menuItems: ['된장국', '현미밥', '된장찌개', '제육볶음', '볶음김치', '플레인 요구르트'],
    ),
    MenuItem(
      date: "2024-03-21",
      menuItems: ['된장국', '현미밥', '된장찌개', '제육볶음', '볶음김치', '플레인 요구르트'],
    ),
    MenuItem(
      date: "2024-03-22",
      menuItems: ['된장국', '현미밥', '된장찌개', '제육볶음', '볶음김치', '플레인 요구르트'],
    ),
    MenuItem(
      date: "2024-03-23",
      menuItems: ['된장국', '현미밥', '된장찌개', '제육볶음', '볶음김치', '플레인 요구르트'],
    ),
    MenuItem(
      date: "2024-03-24",
      menuItems: ['된장국', '현미밥', '된장찌개', '제육볶음', '볶음김치', '플레인 요구르트'],
    ),
  ];

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
            name = userData['name'];
            studentId = userData['studentId'];
            major = userData['major'];
            grade = userData['grade'];
          });
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StuInformation()),
          );
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  MenuItem getMenuForDate(DateTime date) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return menuList.firstWhere((menuItem) => menuItem.date == formattedDate, orElse: () => MenuItem(date: formattedDate, menuItems: ['메뉴가 없습니다']));
  }

  void changeDate(int days) {
    setState(() {
      currentDate = currentDate.add(Duration(days: days));
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy.MM.dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    MenuItem menuItem = getMenuForDate(currentDate);

    return WillPopScope(
      onWillPop: () async {
        // 뒤로가기 버튼을 무시
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,  // 뒤로가기 버튼 숨기기
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                icon: SvgPicture.asset('assets/images/ic_alarm.svg'),
                onPressed: () {
                  // 알림 로직 처리

                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.account_circle_outlined, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPage()),
                );
              },
              padding: EdgeInsets.only(right: 20),
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
                                  'assets/images/ic_university.png',
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
                                      Text(name ?? "사용자", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 10,),
                                      Container(
                                        padding: const EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(studentId ?? "", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 7),
                                  Text("$major ${grade ?? ""}학년" ?? "", style: const TextStyle(fontSize: 18)),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => QrPay()),
                            );
                          },
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/ic_pay.svg',
                              width: 84,
                              height: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _pageInfos.map((pageInfo) => customButton(pageInfo, context)).toList(),
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
                            child: Text(formatDate(currentDate), style: const TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: (menuItem.menuItems.length * 29) + 30.0,
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
                                  icon: SvgPicture.asset('assets/images/bg_btn_left.svg'),
                                  onPressed: () {
                                    changeDate(-1);
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width - 200,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: menuItem.menuItems.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 2),
                                          child: Text(
                                            menuItem.menuItems[index],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: SvgPicture.asset('assets/images/bg_btn_right.svg'),
                                  onPressed: () {
                                    changeDate(1);
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
        ),
      ),
    );
  }

  Widget customButton(PageInfo pageInfo, BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        if (pageInfo.page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => pageInfo.page!));
        } else if (pageInfo.url != null) {
          Uri url = Uri.parse(pageInfo.url!);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            throw 'Could not launch $url';
          }
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
                child: SvgPicture.asset(pageInfo.iconPath, width: 30, height: 30),
              ),
            ),
            const SizedBox(height: 8),
            Text(pageInfo.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  final String date;
  final List<String> menuItems;

  MenuItem({required this.date, required this.menuItems});
}
