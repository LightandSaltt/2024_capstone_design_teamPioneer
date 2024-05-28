import 'package:flutter/material.dart';

class InquiryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('1:1 문의'),
      ),
      body: Center(
        child: Text('문의 사항을 제출할 수 있는 폼을 여기에 구현합니다.'),
      ),
    );
  }
}
