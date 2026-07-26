import 'package:flutter/material.dart';
import 'package:larro/mycolors.dart';
import 'package:larro/pages/p_home.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "LRO",
      theme: appTheme,
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}