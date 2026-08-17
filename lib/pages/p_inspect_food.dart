import 'package:flutter/material.dart';
import 'package:larro/manages/save_manager.dart';

class InspectFoodPage extends StatefulWidget {
  const InspectFoodPage({super.key, required this.food});

  final FoodEntry food;

  @override
  State<InspectFoodPage> createState() => _InspectFoodPageState();
}

class _InspectFoodPageState extends State<InspectFoodPage> {
  // Function to delete the current food item
  void deleteItem() async {
    // send the delete to the savemanager
    await SaveManager.instance.deleteFoodById(widget.food.id);

    // pop out of the current inspect page, because the food doesn't exist anymore
    Navigator.pop(context);

    // have to reload the state on the foods homepage so it updates to get all the saved foods
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 5,
        shadowColor: colorScheme.primary,
        backgroundColor: colorScheme.primary,
        title: Text("${widget.food.itemName}, ${widget.food.restaurant}"),
        actions: [
          // 3 dots popup menu to edit and delete it
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(child: Text("Edit...")),
                PopupMenuItem(
                  child: Text("Delete"),
                  onTap: () {
                    deleteItem();
                  },
                ),
              ];
            },
            color: colorScheme.secondary,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.food.dateTime.month}/${widget.food.dateTime.day}/${widget.food.dateTime.year}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.food.rating.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      Image.file(widget.food.image),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: widget.food.tags.map((tag) {
                              return Chip(
                                label: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                  child: Text(
                                    tag,
                                    overflow: TextOverflow
                                        .ellipsis, // long tags get truncated with "..."
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: colorScheme.onSecondaryContainer,
                                    ),
                                  ),
                                ),
                                backgroundColor: colorScheme.secondaryContainer,
                                side: BorderSide.none,
                                labelStyle: TextStyle(
                                  color: colorScheme.surface,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
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
