import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:larro/manages/save_manager.dart';
import 'package:larro/pages/homepages/p_foods.dart';
import 'package:larro/pages/homepages/p_home_empty.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SaveManager.instance.listenable,
      builder: (context, Box box, _) {
        return box.isNotEmpty ? const FoodsPage() : const EmptyHomePage();
      },
    );
  }
}
