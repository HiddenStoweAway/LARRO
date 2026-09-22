import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:larro/managers/save_manager.dart';
import 'package:larro/pages/homepages/p_foods.dart';
import 'package:larro/pages/homepages/p_home_empty.dart';

// This is the actual page your directed to at the start, 
// it controls what you actually see depending on the foods you already have saved
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    /* https://api.flutter.dev/flutter/widgets/ValueListenableBuilder-class.html 
     makes sure HomePage updates whenever whatever your listening to changes.  In this case, the valueListenable
     is synced with something in savemanger (it will look for whenever the foods box changes.)
    */ 
    return ValueListenableBuilder(
      valueListenable: SaveManager.instance.listenable,
      builder: (context, Box box, _) {
        // if the box is empty, then you get sent to the page where you add your FIRST food, 
        // otherwise if you already have foods then you get sent to the food list.
        return box.isNotEmpty ? const FoodsPage() : const EmptyHomePage();
      },
    );
  }
}
