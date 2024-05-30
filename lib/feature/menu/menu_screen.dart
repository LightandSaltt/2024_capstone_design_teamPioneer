import 'package:flutter/material.dart';

class MenuItem {
  final String date;
  final List<String> menuItems;

  MenuItem({required this.date, required this.menuItems});
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  List<MenuItem> _menuList = [
    MenuItem(
      date: "3월20일(월)",
      menuItems: ['된장국','현미밥','된장찌개','제육볶음','볶음김치','플레인 요구르트'],
    ),
    MenuItem(
      date: "3월21일(화)",
      menuItems: ['된장국','현미밥','된장찌개','제육볶음','볶음김치','플레인 요구르트'],
    ),
    MenuItem(
      date: "3월22일(수)",
      menuItems: ['된장국','현미밥','된장찌개','제육볶음','볶음김치','플레인 요구르트'],
    ),
    MenuItem(
      date: "3월23일(목)",
      menuItems: ['된장국','현미밥','된장찌개','제육볶음','볶음김치','플레인 요구르트'],
    ),
    MenuItem(
      date: "3월24일(금)",
      menuItems: ['된장국','현미밥','된장찌개','제육볶음','볶음김치','플레인 요구르트'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('메뉴'),
        leading: IconButton( // 뒤로가기 버튼 추가
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 이동
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 15, left: 20, bottom: 30, right: 20),
        color: const Color(0xFFF4F4F4),
        child: ListView.builder(
          itemCount: _menuList.length,
          itemBuilder: (context, index) {
            return _buildMenuItem(_menuList[index]);
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem(MenuItem menuItem) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 15),
            Text(menuItem.date, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("점심", style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
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
        )
      ],
    );
  }
}
