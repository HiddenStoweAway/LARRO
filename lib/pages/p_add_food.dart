import 'package:flutter/material.dart';
import 'package:larro/components/tag_autocomplete.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final restaurantTEC = TextEditingController();
  final restaurantFocusNode = FocusNode();
  final sampleTags = ["Hello", "Test", "Wahoo"];
  final addedTags = <String>[];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Image.asset("assets/logo.png", height: 200),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      TagAutocomplete(
                        addedTags: addedTags,
                        autocompleteFrom: sampleTags,
                        textEditingController: restaurantTEC,
                        hintText: "Location",
                      ),

                      SizedBox(height: 30),
                    
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: TagAutocomplete(
                          addedTags: addedTags,
                          autocompleteFrom: sampleTags,
                          textEditingController: restaurantTEC,
                          hintText: "Tags",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
