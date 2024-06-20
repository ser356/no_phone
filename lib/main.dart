import 'package:flutter/material.dart';
import 'package:no_phone/aux/page.dart';

void main() {
  runApp(const MyApp(key: Key('myAppKey')));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const MyPage(),
    );
  }
}

