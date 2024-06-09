import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async'; // Timer를 사용하기 위해 추가
import 'package:hansik_app/screens/password_check.dart'; // 비밀번호 확인 화면으로 돌아가기 위한 경로

class QrPay extends StatefulWidget {
  @override
  _QrPayState createState() => _QrPayState();
}

class _QrPayState extends State<QrPay> {
  int ticketCount = 0;
  String? qrCode;
  String? oldestTicketKey;
  late DatabaseReference ticketsRef;
  Timer? _timer;
  int _remainingTime = 30;  // 카운트다운 시간

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTimer(); // 위젯이 빌드된 후 타이머 시작
    });
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

        // 사용 내역 기록 추가
        await userRef.child('usedTickets').push().set({
          'usedAt': DateTime.now().toIso8601String(),
        });
      }
      _loadTickets();  // 식권 정보를 다시 로드하여 상태를 업데이트
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('식권이 사용되었습니다.')),
      );
    }
  }

  void _startTimer() {
    _remainingTime = 30; // 타이머 리셋
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
        // 시간이 다 되면 비밀번호 인증 화면으로 자동 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PasswordCheck()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 페이지 종료 시 타이머 취소
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
              Text('남은 시간: $_remainingTime초'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: ticketCount > 0 ? _useTicket : null,
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
