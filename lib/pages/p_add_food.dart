import 'package:flutter/material.dart';

class AddFoodPage extends StatelessWidget {
  const AddFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Image.asset("assets/logo.png", height: 200),
      ),
      body: Placeholder(),
    );
  }
}
