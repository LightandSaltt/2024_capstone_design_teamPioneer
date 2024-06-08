import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> with SingleTickerProviderStateMixin {
  List<PurchaseHistory> _purchaseHistoryList = [];
  List<UsageHistory> _usageHistoryList = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPurchaseHistory();
    _loadUsageHistory();
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
        }
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
