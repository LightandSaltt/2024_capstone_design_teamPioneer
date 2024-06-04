import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hansik_app/screens/hansik_main_page.dart';
import 'package:hansik_app/screens/inquiry.dart';
import 'package:hansik_app/screens/login.dart';
import 'package:hansik_app/screens/my_hansik_storage.dart';
import 'package:hansik_app/screens/mypage.dart';
import 'package:hansik_app/screens/notification.dart';
import 'package:hansik_app/screens/payment_details.dart';
import 'package:hansik_app/screens/profile_change.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hansik_app/screens/stu_information.dart';

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
      home: AuthCheck(),
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

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _checkAuthStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return snapshot.data ?? LoginScreen();
        }
      },
    );
  }

  Future<Widget> _checkAuthStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return LoginScreen();
    } else {
      final userRef = FirebaseDatabase.instance.reference().child('users').child(user.uid);
      final snapshot = await userRef.get();
      if (snapshot.value == null) {
        return StuInformation();
      } else {
        return HansikMainPage();
      }
    }
  }
}
