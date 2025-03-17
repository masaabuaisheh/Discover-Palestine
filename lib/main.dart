import 'package:flutter/material.dart';
// import 'home_page.dart';
import 'navbar_section.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatting',
      // home: HomePage(),
      home: NavbarSection(),
    );
  }
}
