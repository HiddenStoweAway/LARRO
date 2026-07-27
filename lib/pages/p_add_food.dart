import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:larro/components/tag_autocomplete.dart';
import 'package:larro/manages/save_manager.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final restaurantTEC = TextEditingController();
  final restaurantFocusNode = FocusNode();
  final restaurantAddedTags = <String>[];

  final catagoriesTEC = TextEditingController();
  final catagoriesFocusNode = FocusNode();
  final catagoriesAddedTags = <String>[];

  final ratingTEC = TextEditingController();

  final picker = ImagePicker();
  File? image;

  Future<void> pickImage() async {
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  void addFood() async {
    final manager = SaveManager.instance;

    final foodId = manager.getNextId();

    var errorMessage = "";

    if (restaurantAddedTags.isEmpty) {
      if (restaurantTEC.text.isNotEmpty) {
        restaurantAddedTags.add(restaurantTEC.text);
      } else {
        errorMessage = "Please enter a location.";
      }
    }

    if (ratingTEC.text.isEmpty) {
      errorMessage += "\nPlease enter a rating.";
    }

    if (errorMessage != "") {
      final colorScheme = Theme.of(context).colorScheme;

      final snackBar = SnackBar(
        elevation: 1,
        content: Center(
          child: Text(
            errorMessage,
            style: TextStyle(
              color: colorScheme.onTertiary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        backgroundColor: colorScheme.tertiary,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final entry = FoodEntry(
      id: foodId,
      restaurant: restaurantAddedTags[0],
      tags: catagoriesAddedTags,
      rating: double.parse(ratingTEC.text),
      image: image,
    );

    await manager.saveFoodEntry(entry);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final restaurantAutocorrectTags = SaveManager.instance.getRestaurants();
    final catagoriesAutocorrectTags = SaveManager.instance.getTags();

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        shadowColor: colorScheme.primary,
        backgroundColor: colorScheme.primary,
        title: Image.asset("assets/logo.png", height: 200),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Enter Restaurant Information:",
                  style: TextStyle(
                    fontSize: 18,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
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
                          addedTags: restaurantAddedTags,
                          autocompleteFrom: restaurantAutocorrectTags,
                          textEditingController: restaurantTEC,
                          hintText: "Location",
                          onlyOneTag: true,
                        ),

                        SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: TagAutocomplete(
                            addedTags: catagoriesAddedTags,
                            autocompleteFrom: catagoriesAutocorrectTags,
                            textEditingController: catagoriesTEC,
                            hintText: "Catagories",
                          ),
                        ),

                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            border: Border.all(
                              color: colorScheme.secondary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: 130,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: ratingTEC,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value.isEmpty) return;

                              final parsed = double.tryParse(value);
                              if (parsed != null && parsed > 10) {
                                ratingTEC.text = "10";
                                ratingTEC.selection = TextSelection.collapsed(
                                  offset: ratingTEC.text.length,
                                );
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Rating 0-10",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: colorScheme.secondary,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Upload a photo:",
                  style: TextStyle(
                    fontSize: 18,
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                image == null
                    ? GestureDetector(
                        onTap: () {
                          pickImage();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 175,
                          decoration: BoxDecoration(
                            color: colorScheme.secondary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.upload,
                            color: colorScheme.secondaryContainer,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: pickImage,
                        child: Image.file(image!),
                      ),

                SizedBox(height: 30),
                SizedBox(
                  width: 175,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondaryContainer,
                      side: BorderSide(color: colorScheme.secondary, width: 2),
                    ),
                    onPressed: () {
                      addFood();
                    },
                    child: Icon(
                      Icons.add,
                      color: colorScheme.secondary,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
