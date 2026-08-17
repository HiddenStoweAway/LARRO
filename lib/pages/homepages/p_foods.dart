import 'package:flutter/material.dart';
import 'package:larro/manages/save_manager.dart';
import 'package:larro/pages/p_add_food.dart';
import 'package:larro/pages/p_inspect_food.dart';

class FoodsPage extends StatefulWidget {
  const FoodsPage({super.key});

  @override
  State<FoodsPage> createState() => _FoodsPageState();
}

class _FoodsPageState extends State<FoodsPage> {
  // "ALL" will be automatically added as a tag, and it is just every food, not just the specific ones
  final Map<String, List<FoodEntry>> foodsByTag = {"ALL": []};
  final openedTags = [];

  // When a food item is clicked on, it sends it to the inspect page of that food
  void openFood(FoodEntry food) {
    Navigator.of(context).push(
      // pass the food as a argument
      MaterialPageRoute(builder: (snapshot) => InspectFoodPage(food: food)),
    );
  }

  // On build, each tag dropdown is filled up with all the foods that share that tag
  Future<void> fillFoodsByTag() async {
    // clear it to restart
    foodsByTag.clear();
    // add the "ALL" tag
    foodsByTag.addAll({"ALL": []});

    // Get all the foods that are saved
    final foodEntries = await SaveManager.instance.getFoodEntrys();
    for (var food in foodEntries) {
      for (var tag in food.tags) {
        // iterates through every tag the food has.

        if (foodsByTag.keys.contains(tag)) {
          // if the tag is already an index, then just add the food to the list at that index.
          foodsByTag[tag]!.add(food);
        } else {
          // otherwise, then add a new index, being the tag, and add the food in it.
          foodsByTag.addAll({
            tag: [food],
          });
        }
      }

      // Do the same thing as ^up there, except with the foodname parameter, but just add it into foodsByTag.
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
    // Grab the colorscheme
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      // call async function
      future: fillFoodsByTag(),
      builder: (context, snapshot) {
        // order all the tags alphabetically, except "ALL" goes last.
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
              // IconButton(
              //   onPressed: () async {
              //     await SaveManager.instance.deleteData();
              //   },
              //   icon: Icon(Icons.close),
              // ),
            ],
          ),
          body: SingleChildScrollView(
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: colorScheme.primaryContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  children: [
                    ...sortedEntries.map((value) {
                      // sort all the foods under a tag by rating
                      final sortedValues = value.value
                        ..sort((a, b) {
                          return -a.rating.compareTo(
                            b.rating,
                          ); // this is ascending, we want it descending
                        });

                      // get the list of all the foods widgets, to be used later
                      final widgetChildren = sortedValues.map((entry) {
                        return ListTile(
                          onTap: () {
                            openFood(entry);
                          },
                          splashColor: colorScheme.primary,
                          leading: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Image.file(entry.image),
                          ),
                          title: Text(
                            entry.restaurant,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            "${entry.rating}   |   ${entry.dateTime.month}/${entry.dateTime.day}/${entry.dateTime.year - 2000}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        );
                      }).toList();

                      // if the tag is "ALL", then there is no dropdown, everything is just there by itself.
                      if (value.key == "ALL") {
                        return Column(children: widgetChildren);
                      }

                      // The food dropdown
                      return ExpansionTile(
                        backgroundColor: colorScheme.primaryContainer,
                        collapsedBackgroundColor: colorScheme.secondary,
                        leading: sortedValues.isNotEmpty
                            ? Image.file(sortedValues[0].image)
                            : Icon(Icons.question_mark),
                        title: Text(
                          value.key,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // All the foods under the dropdown
                        children: widgetChildren,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
