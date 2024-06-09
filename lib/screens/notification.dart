import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Hansik App 출시',
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey,
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: Container(),
                    secondChild: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '한남대학교 학교 식당 전자결제 시스템 애플리케이션 Hansik이 최초로 출시되었습니다. 많은 이용 부탁드립니다.',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                    crossFadeState: _isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationScreen(),
  ));
}
