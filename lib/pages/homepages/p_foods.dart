import 'package:flutter/material.dart';
import 'package:larro/manages/save_manager.dart';
import 'package:larro/pages/p_add_food.dart';

class FoodsPage extends StatefulWidget {
  const FoodsPage({super.key});

  @override
  State<FoodsPage> createState() => _FoodsPageState();
}

class _FoodsPageState extends State<FoodsPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final saveManager = SaveManager.instance;

    final tags = saveManager.getTags();
    print(saveManager.getRestaurants());

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
              color: colorScheme.secondaryContainer,
              child: Column(
                children: [
                  ...tags.map((value) {
                    return Container(
                      width: double.infinity,
                      height: 75,
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        border: BoxBorder.all(
                          color: colorScheme.secondaryContainer,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // just to make the spacing symetrical
                          Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: colorScheme.secondary,
                          ),

                          Text(
                            value,
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
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
