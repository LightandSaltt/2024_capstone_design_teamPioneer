import 'package:flutter/material.dart';

class PaymentDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('결제 내역'),
      ),
      body: Center(
        child: Text('여기에 사용자의 결제 내역을 표시합니다.'),
      ),
    );
  }
}
