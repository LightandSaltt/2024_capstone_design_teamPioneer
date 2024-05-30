import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hansik_app/screens/hansik_main_page.dart';
import 'package:hansik_app/screens/inquiry.dart';
import 'package:hansik_app/screens/my_hansik_storage.dart';
import 'package:hansik_app/screens/mypage.dart';
import 'package:hansik_app/screens/notification.dart';
import 'package:hansik_app/screens/payment_details.dart';
import 'package:hansik_app/screens/profile_change.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'hansik_app',
      debugShowCheckedModeBanner: false,
      home: HansikMainPage(), // LoginScreen을 여기서 호출

      routes: {
        '/profile_change': (context) => ProfileChangeScreen(),
        '/my_hansik_storage': (context) => MyHansikStorageScreen(),
        '/payment_details': (context) => PaymentDetailsScreen(),
        '/inquiry': (context) => InquiryScreen(),
        '/notification': (context) => NotificationScreen(),
      },
    );
  }
}
