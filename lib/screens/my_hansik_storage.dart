import 'package:flutter/material.dart';

class MyHansikStorageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 식권함'),
      ),
      body: Center(
        child: Text('식권 관련 내용이 표시됩니다.'),
      ),
    );
  }
}
