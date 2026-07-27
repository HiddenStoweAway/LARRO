import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class SaveManager {
  static SaveManager instance = SaveManager();

  int getNextId(){
    return getFoodEntrys().length;
  }

  Future<void> saveFoodEntry(FoodEntry food) async {
    final dir = await getApplicationDocumentsDirectory();
    final box = Hive.box('foods');

    final savedImagePath = await food.image.copy('${dir.path}/${food.id}');

    await box.add({
      "id": food.id,
      "restaurant": food.restaurant,
      "tags": food.tags,
      "rating": food.rating,
      "imagePath": savedImagePath,
    });
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
