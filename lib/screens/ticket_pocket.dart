import 'package:flutter/material.dart';
import 'buy_ticket.dart';

class TicketPocket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QR 결제',
          style: TextStyle(
            fontWeight: FontWeight.bold,  // 글씨를 두껍게 만듭니다.
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.1),  // 반투명 회색으로 설정
        child: Center(
          child: Text(
            '여기에 원하는 내용을 추가하세요.', // 텍스트를 중앙에 배치합니다.
            style: TextStyle(fontSize: 16),  // 텍스트 스타일을 지정합니다.
          ),
        ),
      ),
    );
  }
}
