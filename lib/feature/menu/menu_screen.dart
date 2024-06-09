import 'package:flutter/material.dart';

class MenuItem {
  final String date;
  final List<String> breakfast;
  final List<String> lunch;
  final List<String> dinner;

  MenuItem({
    required this.date,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  MenuItem.lunchOnly({
    required this.date,
    required this.lunch,
  })  : breakfast = [],
        dinner = [];
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<MenuItem> _mensahMenu = [
    MenuItem.lunchOnly(
      date: "2024-06-10",
      lunch: ['백미밥', '순두부찌개', '생선까스&소스', '도토리묵야채무침', '건파래볶음', '배추김치'],
    ),
    MenuItem.lunchOnly(
      date: "2024-06-11",
      lunch: ['백미밥', '아욱국', '돈육떡고추장볶음', '양배추찜&쌈장', '부추적채겉절이', '배추김치'],
    ),
    MenuItem.lunchOnly(
      date: "2024-06-12",
      lunch: ['단호박카레라이스', '미역국', '어린잎너비아니구이', '브로콜리초회', '요구르트', '배추김치'],
    ),
    MenuItem.lunchOnly(
      date: "2024-06-13",
      lunch: ['백미밥', '시래기국', '오징어야채볶음', '두부양념구이', '토마토커리겉절이', '배추김치'],
    ),
    MenuItem.lunchOnly(
      date: "2024-06-14",
      lunch: ['백미밥', '잔치국수', '메밀전병', '오징어초무침', '후식음료', '배추김치'],
    ),
  ];

  final List<MenuItem> _dormitoryMenu = [
    MenuItem(
      date: "2024-06-10",
      breakfast: ['브레드', '쌀씨리얼&우유', '삶은계란', '토마토채소샐러드', '후르츠칵테일'],
      lunch: ['쌀밥', '순두부김치국', '오삼불고기', '고구마맛탕', '토마토치커리유자샐러드', '깍두기'],
      dinner: ['쌀밥', '어묵국', '고등어구이', '비엔나김치볶음', '콩나물무침', '깍두기'],
    ),
    MenuItem(
      date: "2024-06-11",
      breakfast: ['모닝빵&과일잼', '쌀씨리얼&우유', '셀프계란후라이', '양배추샐러드&드레싱', '옥수수스프'],
      lunch: ['유부우동', '쌀밥', '찹쌀꽈배기', '매운단무지', '도토리묵상추무침', '배추김치'],
      dinner: ['쌀밥', '콩나물국', '새우커틀릿', '순대떡볶이', '땅콩조림', '깍두기'],
    ),
    MenuItem(
      date: "2024-06-12",
      breakfast: ['삼각김밥', '음료수', '삶은계란', '과일샐러드', '꿀호떡'],
      lunch: ['스팸김치볶음밥', '얼갈이된장국', '감자고로케', '오이무침', '요쿠르트', '깍두기'],
      dinner: ['쌀밥', '수제비국', '제육고추장불고기', '볼어묵조림', '다시마튀각', '배추김치'],
    ),
    MenuItem(
      date: "2024-06-13",
      breakfast: ['모닝빵&과일잼', '쌀씨리얼&우유', '셀프계란후라이', '양배추샐러드&드레싱', '감자샐러드'],
      lunch: ['쌀밥', '팽이버섯유부장국', '치킨까스', '쫄면무침', '양배추샐러드', '배추김치'],
      dinner: ['쌀밥', '두부김치국', '모듬장조림', '춘권튀김', '상추겉절이', '깍두기'],
    ),
    MenuItem(
      date: "2024-06-14",
      breakfast: ['삼각김밥', '음료수', '삶은계란', '푸딩', '과일'],
      lunch: ['쌀밥', '사골떡국', '오리훈제굴소스볶음', '알감자조림', '무생채', '배추김치'],
      dinner: ['쌀밥', '열무된장국', '코다리조림', '스모크햄구이', '연근조림', '배추김치'],
    ),
  ];

  final List<MenuItem> _daedeokValleyMenu = [
    MenuItem.lunchOnly(
      date: "2024-06-10",
      lunch: ['백미밥', '얼큰김칫국', '매콤돈사태찜', '생선커틀릿', '오리엔탈푸실리파스타', '배추김치', '결명자차'],
    ),
    MenuItem.lunchOnly(
      date: "2024-06-11",
      lunch: ['백미밥', '배추된장국', '제육볶음', '한식잡채', '양념고추지', '배추김치', '옥수수차'],
    ),
    MenuItem.lunchOnly(
      date: "2024-06-12",
      lunch: ['소고기버섯콩나물밥', '미역국', '타코야끼', '연두부찜&양념장', '부추무생채', '열무김치', '우엉차'],
    ),
    MenuItem.lunchOnly(
      date: "2024-06-13",
      lunch: ['백미밥', '가쓰오장국', '순살등심돈까스', '국물떡볶이', '양배추샐러드', '배추김치', '보리차'],
    ),
    MenuItem.lunchOnly(
      date: "2024-06-14",
      lunch: ['백미밥', '콩비지찌개', '데리야끼고기완자', '해물볶음우동', '오이생채', '배추김치', '결명자차'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('메뉴'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '멘사'),
            Tab(text: '생활관'),
            Tab(text: '대덕밸리'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMenuListView(_mensahMenu, isDormitory: false),
          _buildMenuListView(_dormitoryMenu, isDormitory: true),
          _buildMenuListView(_daedeokValleyMenu, isDormitory: false),
        ],
      ),
    );
  }

  Widget _buildMenuListView(List<MenuItem> menuList, {required bool isDormitory}) {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 20, bottom: 30, right: 20),
      color: const Color(0xFFF4F4F4),
      child: ListView.builder(
        itemCount: menuList.length,
        itemBuilder: (context, index) {
          return _buildMenuItem(menuList[index], isDormitory: isDormitory);
        },
      ),
    );
  }

  Widget _buildMenuItem(MenuItem menuItem, {required bool isDormitory}) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 15),
            Text(menuItem.date, style: const TextStyle(fontSize: 18)),
          ],
        ),
        const SizedBox(height: 5),
        if (isDormitory)
          ...[
            _buildMealSection('아침', menuItem.breakfast),
            _buildMealSection('점심', menuItem.lunch),
            _buildMealSection('저녁', menuItem.dinner),
          ]
        else
          _buildMealSection('점심', menuItem.lunch),
      ],
    );
  }

  Widget _buildMealSection(String mealType, List<String> menuItems) {
    return ExpansionTile(
      title: Text(mealType, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      children: menuItems.map((item) => ListTile(
        title: Text(item, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
      )).toList(),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MenuScreen(),
  ));
}
