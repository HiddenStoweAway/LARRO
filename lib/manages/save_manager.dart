import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class SaveManager {
  static SaveManager instance = SaveManager();

  ValueListenable<Box> get listenable => Hive.box('foods').listenable();

  int getNextId() {
    final entries = getFoodEntrys();
    if (entries.isEmpty) return 0;

    // gets the greatest id in the box, then adds one.
    return entries.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  Future<void> saveFoodEntry(FoodEntry food) async {
    final dir = await getApplicationDocumentsDirectory();
    final box = Hive.box('foods');

    final savedImage = await food.image.copy('${dir.path}/${food.id}');

    await box.add({
      "id": food.id,
      "restaurant": food.restaurant,
      "tags": food.tags,
      "rating": food.rating,
      "imagePath": savedImage.path,
    });

    await saveRestaurant(food.restaurant);

    await saveTags(food.tags);
  }

  List<FoodEntry> getFoodEntrys() {
    final entries = Hive.box('foods').values.toList();

    final foodEntries = entries.map((entry) {
      return FoodEntry(
        id: entry['id'],
        restaurant: entry['restaurant'],
        tags: entry['tags'],
        rating: entry['rating'],
        image: File(entry['imagePath']),
      );
    }).toList();

    return foodEntries;
  }

  Future<void> saveTags(List<String> tags) async {
    final existingTags = Hive.box("tags").values;
    final newTags = tags.where(
      (tag) => !existingTags.contains(tag),
    ); // all unsaved tags
    for (final tag in newTags) {
      Hive.box('tags').add(tag);
    }
  }

  Future<void> saveRestaurant(String restaurant) async {
    final existingRestaurants = Hive.box("restaurants").values;
    if (!existingRestaurants
        .map((value) => value.toLowerCase())
        .contains(restaurant.toLowerCase())) {
      Hive.box('restaurants').add(restaurant);
    }
  }

  List<String> getTags() {
    return Hive.box("tags").values.cast<String>().toList();
  }

  List<String> getRestaurants() {
    return Hive.box("restaurants").values.cast<String>().toList();
  }

  Future<void> deleteData() async {
    await Hive.box('foods').clear();
    await Hive.box('tags').clear();
    await Hive.box('restaurants').clear();
  }
}

class FoodEntry {
  int id;
  String restaurant;
  List<String> tags;
  double rating;
  File image;

  FoodEntry({
    required this.id,
    required this.restaurant,
    required this.tags,
    required this.rating,
    required this.image,
  });
}
