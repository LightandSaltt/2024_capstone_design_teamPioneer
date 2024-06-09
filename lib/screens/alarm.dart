import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> with SingleTickerProviderStateMixin {
  List<PurchaseHistory> _purchaseHistoryList = [];
  List<UsageHistory> _usageHistoryList = [];
  late TabController _tabController;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeNotifications();
    _loadPurchaseHistory();
    _loadUsageHistory();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your_channel_id', 'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  void _loadPurchaseHistory() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final databaseRef = FirebaseDatabase.instance.ref('users/${user.uid}/purchaseHistory');
        final snapshot = await databaseRef.get();

        if (snapshot.exists) {
          Map<dynamic, dynamic> historyMap = snapshot.value as Map<dynamic, dynamic>;
          List<PurchaseHistory> historyList = historyMap.entries.map((entry) {
            Map<String, dynamic> data = Map<String, dynamic>.from(entry.value);
            return PurchaseHistory(
              ticketCount: data['ticketCount'],
              amount: data['amount'],
              timestamp: data['timestamp'],
            );
          }).toList();

          // Sort by timestamp
          historyList.sort((a, b) => DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));

          setState(() {
            _purchaseHistoryList = historyList;
          });

          // Show notification
          _showNotification('구매 내역 업데이트', '새로운 구매 내역이 있습니다.');
        }
      }
    } catch (e) {
      print("Error loading purchase history: $e");
    }
  }

  void _loadUsageHistory() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final databaseRef = FirebaseDatabase.instance.ref('users/${user.uid}/usedTickets');
        final snapshot = await databaseRef.get();

        if (snapshot.exists) {
          Map<dynamic, dynamic> historyMap = snapshot.value as Map<dynamic, dynamic>;
          List<UsageHistory> historyList = historyMap.entries.map((entry) {
            Map<String, dynamic> data = Map<String, dynamic>.from(entry.value);
            return UsageHistory(
              usedAt: data['usedAt'],
            );
          }).toList();

          // Sort by timestamp
          historyList.sort((a, b) => DateTime.parse(b.usedAt).compareTo(DateTime.parse(a.usedAt)));

          setState(() {
            _usageHistoryList = historyList;
          });

          // Show notification
          _showNotification('사용 내역 업데이트', '새로운 사용 내역이 있습니다.');
        } else {
          print("No usage history data found.");
        }
      } else {
        print("User is not logged in.");
      }
    } catch (e) {
      print("Error loading usage history: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('결제 및 사용 내역'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '결제 내역'),
            Tab(text: '사용 내역'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(_purchaseHistoryList, true),
          _buildList(_usageHistoryList, false),
        ],
      ),
    );
  }

  Widget _buildList(List<dynamic> items, bool isPurchase) {
    if (items.isEmpty) {
      return Center(child: Text('내역이 없습니다.'));
    }
    return ListView(
      children: items.map((item) {
        return ListTile(
          title: Text(isPurchase ? '티켓 ${item.ticketCount}장 구매' : '식권 사용'),
          subtitle: isPurchase ? Text('총 결제 금액: ${item.amount}원') : null,
          trailing: Text(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(isPurchase ? item.timestamp : item.usedAt))),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class PurchaseHistory {
  final int ticketCount;
  final int amount;
  final String timestamp;

  PurchaseHistory({
    required this.ticketCount,
    required this.amount,
    required this.timestamp,
  });
}

class UsageHistory {
  final String usedAt;

  UsageHistory({
    required this.usedAt,
  });
}
