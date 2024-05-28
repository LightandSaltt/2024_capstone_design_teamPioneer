import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 580,  // ListView의 높이를 제한
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
      title: Row(
        children: [
          Text(
              'My page',
              style: TextStyle(
                fontSize: 34,
                color: Color(0xFF32810D),
                fontWeight: FontWeight.bold,
              )),
        ],
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
      padding: EdgeInsets.only(top: 20.0),  // 상단에 20 픽셀의 패딩을 추가
      children: [
        Container(
          padding: EdgeInsets.only(left: 20.0, top: 10, right: 10, bottom: 10),  // '계정' 텍스트의 패딩을 조정
          color: Color(0xFFF2F4F8),
          child: Text('계정', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        MyPageTile(title: '프로필 변경', navigateTo: '/profile_change'),
        Divider(),
        MyPageTile(title: '나의 식권함', navigateTo: '/my_hansik_storage'),
        Container(
          padding: EdgeInsets.only(left: 20.0, top: 10, right: 10, bottom: 10),  // '결제 및 문의' 텍스트의 패딩을 조정
          color: Color(0xFFF2F4F8),
          child: Text('결제 및 문의', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        MyPageTile(title: '결제 내역', navigateTo: '/payment_details'),
        Divider(),
        MyPageTile(title: '1:1 문의', navigateTo: '/inquiry'),
        Divider(),
        MyPageTile(title: '공지사항', navigateTo: '/notification'),
        Divider(),
      ],
    );
  }
}


class MyPageTile extends StatelessWidget {
  final String title;
  final String navigateTo;

  const MyPageTile({Key? key, required this.title, required this.navigateTo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, navigateTo);
      },
    );
  }
}

class MyPageLogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF32810D),
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 50),
        ),
        onPressed: () async {
          await FirebaseAuth.instance.signOut(); // 로그아웃 처리
          // 로그인 화면으로 이동
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