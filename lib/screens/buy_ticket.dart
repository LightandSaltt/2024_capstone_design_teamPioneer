import 'package:flutter/material.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'stu_information.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class BuyTicket extends StatefulWidget {
  const BuyTicket({super.key});

  @override
  State<BuyTicket> createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
  final double imageWidth = 300.0;  // 이미지의 너비 설정
  final double imageHeight = 200.0; // 이미지의 높이 설정
  int _ticketCount = 1; // 초기 티켓 구매 수량
  String? name;
  String? studentId;
  String? major;
  String? grade;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final databaseRef = FirebaseDatabase.instance.ref();
        final snapshot = await databaseRef.child('users/${user.uid}').get();

        if (snapshot.exists) {
          final userData = snapshot.value as Map<dynamic, dynamic>;
          setState(() {
            name = userData['name'] as String?;
            studentId = userData['studentId'] as String?;
            major = userData['major'] as String?;
            grade = userData['grade'] as String?;
          });
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StuInformation()),
          );
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  void _showConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("결제 확인"),
          content: Text("$_ticketCount장을 결제하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              child: Text("취소"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("결제하기"),
              onPressed: () {
                Navigator.of(context).pop();
                _startPayment();
              },
            ),
          ],
        );
      },
    );
  }

  void _startPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Payment(
          ticketCount: _ticketCount,
          name: name,
          studentId: studentId,
          major: major,
          grade: grade,
        ),
      ),
    );
  }

  void _incrementCount() {
    setState(() {
      _ticketCount++;
    });
  }

  void _decrementCount() {
    if (_ticketCount > 1) {
      setState(() {
        _ticketCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(''),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 60.0, top: 30.0),
            child: Image.asset(
              'assets/images/food.png',
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: '식권\n\n',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '평균 필요량 영양소 섭취기준으로 건강하게 식사 메뉴를 구성하여 건강한 한끼를 제공합니다.',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20), // 선 위의 공간을 추가
          Divider(
            color: Colors.black45,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            height: 20, // 선의 높이를 조정
          ),
          SizedBox(height: 20), // 선 아래의 공간을 추가
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "가격",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "4500원",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20), // 가격과 아래 박스 사이의 공간 추가
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.grey[300],
              width: double.infinity,
              child: Text(
                "메뉴 사진은 연출된 이미지로 실제 조리된 음식과 다를 수 있습니다.",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),  // 숫자 조절 버튼과 박스 사이에 간격 추가
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),  // 조절 버튼을 살짝 위로 배치
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 40,  // 버튼의 너비 설정
                  height: 40,  // 버튼의 높이 설정
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: IconButton(
                    iconSize: 20,  // 아이콘 크기 설정
                    icon: Icon(Icons.remove),
                    onPressed: _decrementCount,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    '$_ticketCount',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 40,  // 버튼의 너비 설정
                  height: 40,  // 버튼의 높이 설정
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: IconButton(
                    iconSize: 20,  // 아이콘 크기 설정
                    icon: Icon(Icons.add),
                    onPressed: _incrementCount,
                  ),
                ),
                SizedBox(width: 20),  // 오른쪽 하단 버튼과의 간격 확보
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.green,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: _showConfirmation,
              child: Text("${4500 * _ticketCount}원 결제하기"),
            ),
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 아임포트 결제 모듈 호출',
      routes: {
        '/': (context) => const HomePage(),
        '/result': (context) => const ResultPage(),
      },
      initialRoute: '/',
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아임포트 결제 모듈 호출 예제'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BuyTicket(),
              ),
            );
          },
          child: const Text('식권 구매하기'),
        ),
      ),
    );
  }
}

class Payment extends StatelessWidget {
  final int ticketCount;
  final String? name;
  final String? studentId;
  final String? major;
  final String? grade;

  const Payment({
    super.key,
    required this.ticketCount,
    required this.name,
    required this.studentId,
    required this.major,
    required this.grade,
  });

  void handlePaymentResult(BuildContext context, Map<String, String> result) {
    // 결제 결과 콘솔 출력
    print('결제 결과: $result');

    // 결과 표시
    String message;
    if (result['error_code'] == 'F400') {
      message = '식권 구매가 취소되었습니다.';
    } else {
      message = '식권 ${ticketCount}장이 구매 완료되었습니다.'; // 계좌의 잔액 부족일 경우 에러 처리 아직 안 됌.
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('결제 결과'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();  // 결제 페이지 닫기
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IamportPayment(
        appBar: AppBar(
          title: const Text('식권 결제'),
        ),
        /* 웹뷰 로딩 컴포넌트 */
        initialChild: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/mark2.png'),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                const Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),
        userCode: 'imp05572687',  // 가맹점 식별코드
        /* 결제 데이터 */
        data: PaymentData(
            pg: 'tosspayments',                                          // PG사
            payMethod: 'card',                                           // 결제수단
            name: '한남대학교 학생 식당 식권 구매' ,                                  // 주문명
            merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}', // 주문번호
            amount: 4500 * ticketCount,                                  // 결제금액
            buyerName: name,                                           // 구매자 이름
            buyerTel: '01012345678',                                     // 구매자 연락처
            buyerEmail: studentId,                             // 구매자 이메일 -> 학번
            buyerAddr: '한남대학교 학생 식당',                         // 구매자 주소
            buyerPostcode: '06018',                                      // 구매자 우편번호
            appScheme: 'supertoss://',                                   // 앱 URL scheme
            cardQuota : [2,3]                                            // 결제창 UI 내 할부개월수 제한
        ),
        /* 콜백 함수 */
        callback: (Map<String, String> result) {
          handlePaymentResult(context, result);
        },
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, String>? result = ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('결제 결과'),
      ),
      body: Center(
        child: Text('결제 결과: $result'),
      ),
    );
  }
}
