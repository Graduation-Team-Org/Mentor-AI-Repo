import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mentor AI',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: SpScreen(),
    );
  }
}
