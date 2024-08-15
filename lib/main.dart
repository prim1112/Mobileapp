import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(useMaterial3: false),  //ไม่ใช้เมท3 แต่ปจบต้องใช้3
      title: 'Flutter Demo',
      home: LoginPage(),
    );
  }
}
