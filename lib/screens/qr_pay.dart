import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QrPay extends StatefulWidget {
  @override
  _QrPayState createState() => _QrPayState();
}

class _QrPayState extends State<QrPay> {
  int ticketCount = 0;  // 티켓 수 기본값
  String? qrCode;  // 가장 오래된 티켓의 QR 코드
  String? oldestTicketKey;
  late DatabaseReference ticketsRef;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  void _initializeDatabase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        ticketsRef = FirebaseDatabase.instance.ref('users/${user.uid}/tickets');
        _loadTickets();
      }
    } catch (e) {
      print("데이터베이스 초기화 중 오류: $e");
    }
  }

  void _loadTickets() {
    ticketsRef.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        Map<dynamic, dynamic> tickets = snapshot.value as Map<dynamic, dynamic>;
        if (tickets.isNotEmpty) {
          var sortedKeys = tickets.keys.toList()
            ..sort((a, b) => tickets[a]['timestamp'].compareTo(tickets[b]['timestamp']));
          var oldestTicket = tickets[sortedKeys.first];
          setState(() {
            ticketCount = tickets.length;
            qrCode = oldestTicket['qrCode'];
            oldestTicketKey = sortedKeys.first;
          });
        } else {
          setState(() {
            ticketCount = 0;
            qrCode = null;
            oldestTicketKey = null;
          });
        }
      } else {
        setState(() {
          ticketCount = 0;
          qrCode = null;
          oldestTicketKey = null;
        });
        print('데이터가 없습니다.');
      }
    });
  }

  void _useTicket() async {
    if (oldestTicketKey != null) {
      await ticketsRef.child(oldestTicketKey!).remove();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${user.uid}');
        DataSnapshot userSnapshot = await userRef.child('ticketCount').get();
        if (userSnapshot.exists) {
          int currentCount = int.tryParse(userSnapshot.value.toString()) ?? 0;
          int newCount = currentCount - 1;
          await userRef.child('ticketCount').set(newCount);
        }
      }
      _loadTickets();  // 식권 정보를 다시 로드하여 상태를 업데이트
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('식권이 사용되었습니다.')),
      );
    }
  }

  @override
  void dispose() {
    ticketsRef.onValue.drain();  // 리스너 종료
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QR 결제',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                '식권 개수: $ticketCount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.1),
        child: Center(
          child: ticketCount > 0 && qrCode != null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                data: qrCode!,
                version: QrVersions.auto,
                size: 200.0,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: ticketCount > 0 ? _useTicket : null, // 버튼 활성화 조건
                child: Text('식권 사용'),
              ),
            ],
          )
              : Text(
            '사용 가능한 식권이 없습니다.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}