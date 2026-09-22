import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class SaveManager {
  static SaveManager instance = SaveManager();

  // This listens for anytime the stuff in foods box changes
  ValueListenable<Box> get listenable => Hive.box('foods').listenable();

  // To init Hive, you need to open all the boxes where everything is stored 
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized(); // make sure everything good, i don't really know what this one does.
    await Hive.initFlutter(); // init hive

    // Where food data is stored
    await Hive.openBox("foods");

    // where used tags are stored
    await Hive.openBox("tags");
    await Hive.openBox("restaurants");
    await Hive.openBox("items");
  }

  // get's a new id for a new food
  Future<int> getNextId() async {
    final entries = await getFoodEntrys();
    if (entries.isEmpty) return 0;

    // gets the greatest id in the box, then adds one.
    return entries.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  // saves a new food entry
  Future<void> saveFoodEntry(FoodEntry food) async {
    final dir = await getApplicationDocumentsDirectory(); // this gets the default place the os stores certain documents, and where ima place the files for all the photos
    final box = Hive.box('foods'); // grabs all the food data

    await food.image.copy('${dir.path}/${food.id}'); // copies the photo to the directory.  Note, the photo's file name will just be the food id.

    // adds into the box
    await box.add({
      "id": food.id,
      "restaurant": food.restaurant,
      "tags": food.tags,
      "itemName": food.itemName,
      "rating": food.rating,
      "dateTime": food.dateTime,
    });


    // saves the tags that were used.
    await saveRestaurant(food.restaurant);
    await saveItem(food.itemName);
    await saveTags(food.tags);
  }

  // gets all the already saved food entries
  Future<List<FoodEntry>> getFoodEntrys() async {
    final entries = Hive.box('foods').values.toList(); // pulls the entries from the box as a list
    final dir = await getApplicationDocumentsDirectory(); // grabs the directory where foods are saved.


    final foodEntries = entries.map((entry) { // for each entry
      return FoodEntry( // return a food entry that is put into a list from mapped elements
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

  // save all the food tags in order to use to autocomplete (ex. sweets or desserts)
  Future<void> saveTags(List<String> tags) async {
    final existingTags = Hive.box("tags").values; // gets all the tags already used
    final newTags = tags.where(
      (tag) => !existingTags
          .map((value) => value.toLowerCase()) // turns all the existing tags already used to lowercase
          .contains(tag.toLowerCase()), // then checked to see if the newtag(in lowercase) has already been used and is inside existingTags.  If not, it's apart of newTags
    ); // all unsaved tags

    // for all the newTags, they get added to the box
    for (final tag in newTags) {
      Hive.box('tags').add(tag);
    }
  }

  // save all the different food items(ex. hamburger) to use to autocomplete later
  Future<void> saveItem(String item) async {
    final existingItems = Hive.box("items").values; // grabs all the already used food items that have already been saved
    if (!existingItems
        .map((value) => value.toLowerCase())
        .contains(item.toLowerCase())) {
          // if the foodItem is new, and not in existingItems, it gets added to the box (check saveTags for the logic on how it looks for uniqueness)
      Hive.box('items').add(item);
    }
  }

  // save the restaurants that have been used in order to autocomplete from them later.
  Future<void> saveRestaurant(String restaurant) async {
    final existingRestaurants = Hive.box("restaurants").values; // grabs all the already used restaurants that have already been saved <- don't want dupes in the box
    if (!existingRestaurants
        .map((value) => value.toLowerCase())
        .contains(restaurant.toLowerCase())) {
          // if the foodItem is new, and not in existingItems, it gets added to the box (check saveTags for the logic on how it looks for uniqueness) <- don't want dupes in the box
      Hive.box('restaurants').add(restaurant);
    }
  }

  /*
    These next three functions (getTags, getItems, getRestaurants) grab the tags, food items, and restaurants that have already been used in order to autocomplete from them.
    They all are grabbed from the box as dynamic objects, and then casted to a list of strings.
  */
  
  List<String> getTags() {
    return Hive.box("tags").values.cast<String>().toList();
  }

  List<String> getItems() {
    return Hive.box('items').values.cast<String>().toList();
  }

  List<String> getRestaurants() {
    return Hive.box("restaurants").values.cast<String>().toList();
  }

  // Deletes all the data that has been saved, *not currently used by the total program
  Future<void> deleteData() async {
    // clears each box
    await Hive.box('foods').clear();
    await Hive.box('tags').clear();
    await Hive.box('restaurants').clear();
    await Hive.box('items').clear();

    final dir = await getApplicationDocumentsDirectory();
    if (await dir.exists()) {
      // for everything in the directory, it deletes
      await for (final entity in dir.list()) {
        await entity.delete(recursive: true);
      }
    }
  }

  // allows for individual deleting of foods
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
      // deletes the photo
      await file.delete();
    }

    // deletes the foodItem in the box by the box key
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
    // not updated fully i believe as of 9/21/26
    return 'FoodEntry(id: $id, restaurant: $restaurant, tags: $tags, rating: $rating, image: ${image.path})';
  }
}
