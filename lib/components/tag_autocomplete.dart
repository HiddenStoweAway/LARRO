import 'package:flutter/material.dart';

// MY CUSTOM AUTOCOMPLETE
class TagAutocomplete extends StatefulWidget {
  
  /*
    Required Parameters:
      addedTags: the reference to the added tags
      autocompleteFrom: the tags to autocomplete from 
      textEditingController: the controller to access the actual text
    Non-Required Parameters:
      hintText: the hint text for the text controller
      onlyOneTag: the true/false value for whether or not there is only one tag that will be added to the autocomplete form
        if so, then the tags won't be listen on top 

  */
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

  /*
    Adds the tag from the autocomplete text editor to the list of added tags
  */
  void addTag(String tag) {
    tag = tag.trim(); // get ride of whitespace around the entered tag to add
    if (tag.isEmpty || widget.addedTags.contains(tag)) return; // stop if the tag has been already been added or if the text is empty
    if (widget.onlyOneTag) widget.addedTags.clear(); 
    // if there's only supposed to be one tag then when adding a new tag, clear the list in order for the list to only contain one item

    setState(() {
      widget.addedTags.add(tag);
      if (!widget.autocompleteFrom.contains(tag)) {
        // add the tag to the stuff to autocomplete from if it isn't already in it
        widget.autocompleteFrom.add(tag);
      }

      // clear the text controller.
      widget.textEditingController.clear();
    });
  }

  // removes the tag from all the added tags - NOTE: does not remove it from autocomplete
  void removeTag(String tag) {
    setState(() {
      widget.addedTags.remove(tag);
    });
  }

  // returns everything to autocomplete from 
  Iterable<String> autocompleteOptions(String value) {
    return widget.autocompleteFrom.where(
      // takes everything to autocomplete from where:
      (tag) =>
      // if the value(the current text in the text box) is a part of one of the options to autocomplete from
      // and that option has not been already added it will be returned.
          tag.toLowerCase().contains(value.toLowerCase()) &&
          !widget.addedTags.contains(tag),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // OPTION 1: There's only one tag and the only tag has been added
    if (widget.onlyOneTag && widget.addedTags.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // hint text precedes the actual text box.  It should look like:  {hintText}: _______ 
          Text(
            widget.hintText != null ? "${widget.hintText}: " : "",
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),

          SizedBox(width: 15),

          ...widget.addedTags.map((tag) {
          // for each of the addedTags(should only be one) create a chip that displays the added tag.
            return Chip(
              label: ConstrainedBox(
                constraints: BoxConstraints( // this is setting the size of the actual text at it's max.  It will overflow when it reaches this size
                  maxWidth: MediaQuery.of(context).size.width * 0.3,
                ),

                // the actual text of the tag's text
                child: Text(
                  tag,
                  overflow: TextOverflow
                      .ellipsis, // long tags get truncated with "..."
                  maxLines: 1,
                ),
              ),
              backgroundColor: colorScheme.secondary,
              side: BorderSide.none,
              labelStyle: TextStyle(
                color: colorScheme.surface,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
              onDeleted: () { // each chip should have a little x to delete button
                removeTag(tag);
              },
              deleteIconColor: colorScheme.secondaryContainer,
            );
          }),
        ],
      );
    }

    // OPTION 2: Regular, with all the added tags / no tags
    return Column(
      children: [

        // This lists all the tags already added above the text field as chips
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: widget.addedTags.map((tag) {
            // for each of the tags added on, create a chip widget above the text thingy
            return Chip(
              label: ConstrainedBox(
                constraints: BoxConstraints( // set the max size of the text in case of overflow
                  maxWidth: MediaQuery.of(context).size.width * 0.3,
                ),
                child: Text(
                  tag,
                  overflow: TextOverflow
                      .ellipsis, // long tags get truncated with "..."
                  maxLines: 1,
                ),
              ),
              backgroundColor: colorScheme.secondary,
              side: BorderSide.none,
              labelStyle: TextStyle(
                color: colorScheme.surface,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
              onDeleted: () { // when the little x on the tag is clicked, delete the tag.
                removeTag(tag);
              },
              deleteIconColor: colorScheme.secondaryContainer,
            );
          }).toList(),
        ),

        // This is the actual text field nand autocomplete
        Row(
          children: [
            Expanded(
              child: Autocomplete(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    // if there's nothing in the textfield, then there's nothing to autocomplete from.
                    // FUTURE JOB, add common items to autocomplete from.
                    return Iterable<String>.empty();
                  }
                  
                  // gets all the options from the text that's in the field and gives them to this autocomplete widget
                  return autocompleteOptions(textEditingValue.text);
                },

                textEditingController: widget.textEditingController,
                focusNode: focusNode, // I think this controls when the text field is actaully in focus, for when it's clicked on.

                // happens whenever the autocomplete options are pressed on or selected <- in this case your adding the option as a tag
                onSelected: (tag) {
                  addTag(tag);
                },

                fieldViewBuilder: // this builds out all the actual text field
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
                          final autoCompleteOptions = autocompleteOptions(
                            value,
                          ); // gets all the things you can autocomplete form

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

            // little button next to text field to add the tag
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
