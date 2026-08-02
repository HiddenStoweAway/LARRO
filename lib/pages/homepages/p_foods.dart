import 'package:flutter/material.dart';
import 'package:larro/manages/save_manager.dart';
import 'package:larro/pages/p_add_food.dart';

class FoodsPage extends StatefulWidget {
  const FoodsPage({super.key});

  @override
  State<FoodsPage> createState() => _FoodsPageState();
}

class _FoodsPageState extends State<FoodsPage> {
  final Map<String, List<FoodEntry>> foodsByTag = {"ALL": []};
  final openedTags = [];

  Future<void> fillFoodsByTag() async {
    foodsByTag.clear();
    foodsByTag.addAll({"ALL": []});

    final foodEntries = await SaveManager.instance.getFoodEntrys();
    for (var food in foodEntries) {
      for (var tag in food.tags) {
        if (foodsByTag.keys.contains(tag)) {
          foodsByTag[tag]!.add(food);
        } else {
          foodsByTag.addAll({
            tag: [food],
          });
        }
      }

      if (foodsByTag.keys.contains(food.itemName)) {
        foodsByTag[food.itemName]!.add(food);
      } else {
        foodsByTag.addAll({
          food.itemName: [food],
        });
      }

      foodsByTag["ALL"]!.add(food);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: fillFoodsByTag(),
      builder: (context, snapshot) {
        final sortedEntries = foodsByTag.entries.toList()
          ..sort((a, b) {
            if (a.key == "ALL") return 1; // ALL always goes after
            if (b.key == "ALL") return -1; // anything else goes before ALL
            return a.key.compareTo(
              b.key,
            ); // normal alphabetical for everything else
          });

        return Scaffold(
          backgroundColor: colorScheme.surface,
          floatingActionButton: FloatingActionButton.large(
            onPressed: () async {
              await Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => AddFoodPage()));
              setState(() {});
            },
            shape: const CircleBorder(),
            backgroundColor: colorScheme.secondary,
            child: Icon(Icons.add, color: colorScheme.onSecondary),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          appBar: AppBar(
            elevation: 5,
            shadowColor: colorScheme.primary,
            backgroundColor: colorScheme.primary,
            title: Image.asset("assets/logo.png", height: 200),
            actions: [
              IconButton(
                onPressed: () async {
                  await SaveManager.instance.deleteData();
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ...sortedEntries.map((value) {
                  return ExpansionTile(
                    backgroundColor: colorScheme.primaryContainer,
                    collapsedBackgroundColor: colorScheme.secondary,
                    title: Text(
                      value.key,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      ...value.value.map((entry) {
                        return ListTile(
                          leading: entry.image != null
                              ? Image.file(entry.image!)
                              : null,
                          title: Text(
                            entry.restaurant,
                            style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer),
                          ),
                          trailing: Text(
                            "${entry.dateTime.month}/${entry.dateTime.day}/${entry.dateTime.year - 2000}",
                            style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer),
                          ),
                        );
                      }),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
