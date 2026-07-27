import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:larro/mycolors.dart';
import 'package:larro/pages/homepages/p_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("foods");
  await Hive.openBox("tags");
  await Hive.openBox("restaurants");
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