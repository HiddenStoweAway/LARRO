import 'package:flutter/material.dart';

class TagAutocomplete extends StatefulWidget {
  const TagAutocomplete({
    super.key,
    required this.addedTags,
    required this.autocompleteFrom,
    required this.textEditingController,
    this.hintText,
    this.onlyOneTag = false,
  });
  final List<String> addedTags;
  final List<String> autocompleteFrom;
  final TextEditingController textEditingController;
  final String? hintText;
  final bool onlyOneTag;

  @override
  State<TagAutocomplete> createState() => _TagAutocompleteState();
}

class _TagAutocompleteState extends State<TagAutocomplete> {
  final FocusNode focusNode = FocusNode();

  void addTag(String tag) {
    tag = tag.trim();
    if (tag.isEmpty || widget.addedTags.contains(tag)) return;
    if (widget.onlyOneTag) widget.addedTags.clear();

    setState(() {
      widget.addedTags.add(tag);
      if (!widget.autocompleteFrom.contains(tag)) {
        widget.autocompleteFrom.add(tag);
      }

      widget.textEditingController.clear();
    });
  }

  void removeTag(String tag) {
    setState(() {
      widget.addedTags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.onlyOneTag && widget.addedTags.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Item Name: ",
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontStyle: FontStyle.italic,
            ),
          ),

          SizedBox(width: 15),

          ...widget.addedTags.map((tag) {
            return Chip(
              label: Text(tag),
              backgroundColor: colorScheme.secondary,
              side: BorderSide.none,
              labelStyle: TextStyle(
                color: colorScheme.surface,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
              onDeleted: () {
                removeTag(tag);
              },
              deleteIconColor: colorScheme.secondaryContainer,
            );
          }),
        ],
      );
    }

    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: widget.addedTags.map((tag) {
            return Chip(
              label: Text(tag),
              backgroundColor: colorScheme.secondary,
              side: BorderSide.none,
              labelStyle: TextStyle(
                color: colorScheme.surface,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
              onDeleted: () {
                removeTag(tag);
              },
              deleteIconColor: colorScheme.secondaryContainer,
            );
          }).toList(),
        ),

        Row(
          children: [
            Expanded(
              child: Autocomplete(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return Iterable<String>.empty();
                  }

                  return widget.autocompleteFrom.where(
                    (tag) =>
                        tag.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ) &&
                        !widget.addedTags.contains(tag),
                  );
                },

                textEditingController: widget.textEditingController,
                focusNode: focusNode,

                // happens whenever the autocomplete options are pressed on or selected
                onSelected: (tag) {
                  addTag(tag);
                },

                fieldViewBuilder:
                    (
                      context,
                      textEditingController,
                      focusNode,
                      onFieldSubmitted,
                    ) {
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        autocorrect: false,

                        // happens whenever the use presses enter in the text field
                        onSubmitted: (value) {
                          final autoCompleteOptions = widget.autocompleteFrom
                              .where(
                                (tag) =>
                                    tag.toLowerCase().contains(
                                      value.toLowerCase(),
                                    ) &&
                                    !widget.addedTags.contains(tag),
                              );

                          // if there are no autocomplete options,
                          // then pressing enter will add the tag that's just the text there, no autocomplete
                          if (autoCompleteOptions.isEmpty) {
                            addTag(value);
                          } else {
                            // calls onSelected() from earlier in the Autocomplete
                            onFieldSubmitted();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: colorScheme.primary,
                          ),
                        ),
                      );
                    },
              ),
            ),

            IconButton(
              onPressed: () {
                addTag(widget.textEditingController.text);
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
