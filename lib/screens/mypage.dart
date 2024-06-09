import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';
import 'alarm.dart';
import 'inquiry.dart';
import 'notification.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
        children: [
          Expanded(
            child: MyPageBody(),
          ),
          MyPageLogoutButton(),
        ],
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black), // 뒤로 가기 아이콘
        onPressed: () {
          // 현재 페이지(MyPage)를 pop하여 HansikMainPage로 돌아가기
          Navigator.pop(context);
        },
      ),
      title: Text(
          'My page',
          style: TextStyle(
            fontSize: 34,
            color: Color(0xFF32810D),
            fontWeight: FontWeight.bold,
          )
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class MyPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20.0),
      children: [
        Text('결제 및 문의', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 20), // 텍스트와 첫 타일 사이의 간격
        MyPageTile(title: '결제 내역', destination: AlarmScreen()),
        MyPageTile(title: '1:1 문의', destination: InquiryScreen()),
        MyPageTile(title: '공지사항', destination: NotificationScreen()),
      ],
    );
  }
}

class MyPageTile extends StatelessWidget {
  final String title;
  final Widget destination;

  const MyPageTile({Key? key, required this.title, required this.destination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 16)),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
        },
      ),
    );
  }
}

class MyPageLogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF32810D),
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 50),
        ),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        child: Text('로그아웃', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
