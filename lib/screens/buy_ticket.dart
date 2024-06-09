import 'package:flutter/material.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'stu_information.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart'; // QR 코드 생성 시 고유한 식별자를 생성하기 위해 추가
import 'hansik_main_page.dart'; // HansikMainPage를 가져옵니다.

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
              padding: EdgeInsets.all(10.0),  // 원래 20.0에서 10.0으로 줄임
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

  void handlePaymentResult(BuildContext context, Map<String, String> result) async {
    // 결제 결과 콘솔 출력
    print('결제 결과: $result');

    // 결과 표시
    String message;
    bool isSuccess = false; // 결제 성공 여부 플래그
    if (result['error_code'] == 'F400') {
      message = '결제에 실패하였습니다.\n사유: ${result['error_msg']}';
      print('결제 취소됨: ${result['error_msg']}');
    } else {
      message = '결제가 완료되었습니다.\n\n총 금액: ${4500 * ticketCount}원\n티켓 수: ${ticketCount}장';
      isSuccess = true; // 결제 성공 처리

      // Firebase 데이터베이스 업데이트
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final databaseRef = FirebaseDatabase.instance.ref();
        final ticketRef = databaseRef.child('users/${user.uid}/tickets');
        DatabaseReference userRef = databaseRef.child('users/${user.uid}');
        DatabaseReference historyRef = userRef.child('purchaseHistory');

        for (int i = 0; i < ticketCount; i++) {
          String qrCode = Uuid().v4();  // 고유한 QR 코드 생성
          await ticketRef.push().set({
            'qrCode': qrCode,
            'used': false,
            'timestamp': DateTime.now().toIso8601String(),
          });
          print('티켓 생성: $qrCode');
        }

        // 티켓 개수 업데이트
        DataSnapshot userSnapshot = await userRef.child('ticketCount').get();
        if (userSnapshot.exists) {
          int currentCount = int.tryParse(userSnapshot.value.toString()) ?? 0;
          int newCount = currentCount + ticketCount;
          await userRef.child('ticketCount').set(newCount);
          print('티켓 개수 업데이트: $newCount');
        } else {
          await userRef.child('ticketCount').set(ticketCount);
          print('초기 티켓 개수 설정: $ticketCount');
        }

        // 결제 내역 저장
        await historyRef.push().set({
          'ticketCount': ticketCount,
          'amount': 4500 * ticketCount,
          'timestamp': DateTime.now().toIso8601String(),
        });
        print('결제 내역 저장 완료');
      } else {
        print('사용자가 로그인되어 있지 않습니다.');
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(isSuccess ? '결제가 완료되었습니다.' : '결제가 실패하였습니다.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 20),
              Text(message, style: TextStyle(fontSize: 18)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('확인', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.of(context).pop();  // 결제 결과 대화 상자 닫기
                if (isSuccess) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HansikMainPage()),
                        (Route<dynamic> route) => false,
                  );
                } else {
                  Navigator.of(context).pop();  // 결제 페이지 닫기
                }
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
            buyerEmail: '${studentId}@gm.hannam.ac.kr',                 // 구매자 이메일 -> 학번
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
