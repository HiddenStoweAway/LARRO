import 'package:flutter/material.dart';
import 'package:larro/manages/save_manager.dart';

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
    print(tags);

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
