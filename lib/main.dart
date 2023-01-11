import 'package:flutter/material.dart';
import 'package:formula/models/predictions.dart';
import 'package:formula/pages/home_page.dart';
import 'package:formula/screens/login_screen.dart';

void main() => runApp(Myapp());

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Formula responsive App',
      home: LoginScreen(),
      routes: <String, WidgetBuilder>{
        'home': (pantallainicio) => HomePage(),
      },
    );
  }
}
