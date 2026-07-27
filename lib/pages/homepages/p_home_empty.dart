import 'package:flutter/material.dart';
import 'package:larro/pages/p_add_food.dart';

class EmptyHomePage extends StatelessWidget {
  const EmptyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 5,
        shadowColor: colorScheme.primary,
        backgroundColor: colorScheme.primary,
        title: Image.asset("assets/logo.png", height: 200),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Looking pretty empty...",
              style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
            ),
            SizedBox(height: 5),
            Text(
              "Add a food or drink!",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: colorScheme.tertiary,
              ),
            ),
            SizedBox(height: 15),

            // Alternate Button Option
            // GestureDetector(
            //   child: Container(
            //     width: 175,
            //     height: 50,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(100),
            //       color: colorScheme.secondary,
            //     ),
            //     child: Icon(Icons.add, color: colorScheme.tertiary, size: 25,),
            //   ),
            // ),
            SizedBox(
              width: 175,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                ),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddFoodPage()),
                  );
                },
                child: Icon(
                  Icons.add,
                  color: colorScheme.secondaryContainer,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
