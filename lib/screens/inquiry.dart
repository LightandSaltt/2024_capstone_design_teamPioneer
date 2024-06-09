import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class InquiryScreen extends StatefulWidget {
  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('1:1 문의'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '1:1 문의하기'),
            Tab(text: '나의 문의 내역'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInquiryForm(),
          _buildMyInquiriesTab(),  // '나의 문의 내역' 탭 추가
        ],
      ),
      bottomNavigationBar: _tabController.index == 0
          ? Padding(
        padding: EdgeInsets.all(30.0),
        child: ElevatedButton(
          onPressed: () => _sendInquiry(),
          child: Text('저장하기', style: TextStyle(color: Colors.white, fontSize: 17)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF32810D),
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      )
          : SizedBox.shrink(),
    );
  }

  Widget _buildInquiryForm() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '제목을 입력하세요.',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: '내용을 입력하세요.',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 12,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMyInquiriesTab() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text("로그인이 필요합니다."));
    }

    DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user.uid}/inquiries');

    return StreamBuilder<DatabaseEvent>(
      stream: ref.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return Center(child: Text('No inquiries found.'));
        }

        Map<dynamic, dynamic> inquiries = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
        List<Map<dynamic, dynamic>> items = inquiries.entries.map((entry) => Map<dynamic, dynamic>.from(entry.value)).toList();
        items.sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            var data = items[index];
            DateTime date = DateTime.parse(data['date']);
            bool isDeveloperResponse = data['type'] == 'developer';
            return Container(
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDeveloperResponse ? Colors.grey[300] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(data['inquiry_title'], style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(date)),
                onTap: () {
                  _showInquiryDetail(context, data['inquiry_title'], data['inquiry_detail']);
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showInquiryDetail(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _sendInquiry() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user.uid}/inquiries');

      await ref.push().set({
        'inquiry_title': _titleController.text,
        'inquiry_detail': _contentController.text,
        'date': DateTime.now().toIso8601String(), // 현재 날짜와 시간 저장
        'type': 'user',
      });

      // 알림 팝업 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('문의가 저장되었습니다.'),
            actions: <Widget>[
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _titleController.clear();
                  _contentController.clear();
                },
              ),
            ],
          );
        },
      );

      print('Inquiry saved successfully');
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {});
  }
}
