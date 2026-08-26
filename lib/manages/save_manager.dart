import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class SaveManager {
  static SaveManager instance = SaveManager();

  ValueListenable<Box> get listenable => Hive.box('foods').listenable();

  Future<void> init() async {
      WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Where food data is stored
  await Hive.openBox("foods");

  // where used tags are stored
  await Hive.openBox("tags");
  await Hive.openBox("restaurants");
  await Hive.openBox("items");
  }

  Future<int> getNextId() async {
    final entries = await getFoodEntrys();
    if (entries.isEmpty) return 0;

    // gets the greatest id in the box, then adds one.
    return entries.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  Future<void> saveFoodEntry(FoodEntry food) async {
    final dir = await getApplicationDocumentsDirectory();
    final box = Hive.box('foods');

    await food.image.copy('${dir.path}/${food.id}');

    await box.add({
      "id": food.id,
      "restaurant": food.restaurant,
      "tags": food.tags,
      "itemName": food.itemName,
      "rating": food.rating,
      "dateTime": food.dateTime,
    });

    await saveRestaurant(food.restaurant);
    await saveItem(food.itemName);
    await saveTags(food.tags);
  }

  Future<List<FoodEntry>> getFoodEntrys() async {
    final entries = Hive.box('foods').values.toList();
    final dir = await getApplicationDocumentsDirectory();

    final foodEntries = entries.map((entry) {
      return FoodEntry(
        id: entry['id'],
        itemName: entry['itemName'],
        restaurant: entry['restaurant'],
        tags: entry['tags'],
        rating: entry['rating'],
        image: File("${dir.path}/${entry['id']}"),
        dateTime: entry['dateTime'],
      );
    }).toList();

    return foodEntries;
  }

  Future<void> saveTags(List<String> tags) async {
    final existingTags = Hive.box("tags").values;
    final newTags = tags.where(
      (tag) => !existingTags
          .map((value) => value.toLowerCase())
          .contains(tag.toLowerCase()),
    ); // all unsaved tags

    for (final tag in newTags) {
      Hive.box('tags').add(tag);
    }
  }

  Future<void> saveItem(String item) async {
    final existingItems = Hive.box("items").values;
    if (!existingItems
        .map((value) => value.toLowerCase())
        .contains(item.toLowerCase())) {
      Hive.box('items').add(item);
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

  List<String> getItems() {
    return Hive.box('items').values.cast<String>().toList();
  }

  List<String> getRestaurants() {
    return Hive.box("restaurants").values.cast<String>().toList();
  }

  Future<void> deleteData() async {
    await Hive.box('foods').clear();
    await Hive.box('tags').clear();
    await Hive.box('restaurants').clear();
    await Hive.box('items').clear();
    final dir = await getApplicationDocumentsDirectory();
    if (await dir.exists()) {
      await for (final entity in dir.list()) {
        await entity.delete(recursive: true);
      }
    }
  }

  Future<void> deleteFoodById(int id) async {
    final box = Hive.box('foods');

    // find the Hive key whose stored map has matching 'id'
    final keyToDelete = box.keys.firstWhere(
      (key) => box.get(key)['id'] == id,
      orElse: () => null,
    );

    if (keyToDelete == null) return; // nothing found, nothing to delete

    // also delete the associated image file
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$id");
    if (await file.exists()) {
      await file.delete();
    }

    await box.delete(keyToDelete);
  }
}

class FoodEntry {
  int id;
  String restaurant;
  String itemName;
  List<String> tags;
  double rating;
  File image;
  DateTime dateTime;

  FoodEntry({
    required this.id,
    required this.restaurant,
    required this.itemName,
    required this.rating,
    required this.tags,
    required this.dateTime,
    required this.image,
  });

  @override
  String toString() {
    return 'FoodEntry(id: $id, restaurant: $restaurant, tags: $tags, rating: $rating, image: ${image.path})';
  }
}
