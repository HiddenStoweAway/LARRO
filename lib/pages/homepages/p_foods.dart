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
                Container(
                  child: Column(
                    children: [
                      ...sortedEntries.map((value) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: !openedTags.contains(value.key)
                                    ? 8.0
                                    : 0,
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (openedTags.contains(value.key)) {
                                      openedTags.remove(value.key);
                                    } else {
                                      openedTags.add(value.key);
                                    }
                                  });
                                },
                                borderRadius: BorderRadius.circular(
                                  15,
                                ), // clips splash/highlight to rounded corners
                                splashColor: colorScheme.primaryContainer,
                                child: Ink(
                                  width: double.infinity,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      // just to make the spacing symetrical
                                      Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: colorScheme.secondary,
                                      ),

                                      Text(
                                        value.key,
                                        style: TextStyle(
                                          color: colorScheme.onSecondary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: colorScheme.onSecondary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (openedTags.contains(value.key))
                              ...value.value.map((food) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: InkWell(
                                    onTap: () {},
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ), // clips splash/highlight to rounded corners
                                    splashColor: colorScheme.primaryContainer,
                                    child: Ink(
                                      width: double.infinity,
                                      height: 75,
                                      decoration: BoxDecoration(
                                        color: colorScheme.tertiary,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          if (food.image != null)
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Image.file(food.image!),
                                            ),
                                          Text(
                                            food.restaurant,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.onTertiary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
