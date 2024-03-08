import 'package:flutter/material.dart';

class MultiSelectChip extends StatefulWidget {
  final List<dynamic> itemList;
  final List<dynamic> selectedChoices;
  final String valueField;
  final String labelField;
  final Function(List<dynamic>) onSelectionChanged;

  //Need to pass value and label field simultaneously to get the value and label from the list
  //If valueField and labelField is empty, it will return the item itself
  const MultiSelectChip(
      {required this.itemList,
      this.selectedChoices = const [],
      this.valueField = "",
      this.labelField = "",
      required this.onSelectionChanged});

  @override
  State<MultiSelectChip> createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<dynamic> selectedChoices = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedChoices = List.from(widget.selectedChoices);
    });
  }

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          //Create dropdown button for itemlist
          Container(
            width: double.infinity,
            child: DropdownMenu(
              controller: _textEditingController,
              requestFocusOnTap: true,
              initialSelection:
                  widget.itemList.isNotEmpty ? widget.itemList[0] : "",
              label: Text(
                  widget.labelField != "" ? widget.labelField : "Select item"),
              dropdownMenuEntries:
                  widget.itemList.map<DropdownMenuEntry<dynamic>>((item) {
                return DropdownMenuEntry<dynamic>(
                    value: widget.valueField != ""
                        ? item[widget.labelField]
                        : item,
                    label: widget.labelField != ""
                        ? item[widget.labelField]
                        : item);
              }).toList(),
              onSelected: (value) => {
                setState(() {
                  bool valueNotInSelectedChoice = true;

                  for (var i = 0; i < selectedChoices.length; i++) {
                    if (selectedChoices[i] == value) {
                      valueNotInSelectedChoice = false;
                      break;
                    }
                  }

                  if (valueNotInSelectedChoice && value != null) {
                    selectedChoices.add(value);
                    widget.onSelectionChanged(selectedChoices);
                  }
                })
              },
            ),
          ),
          Container(
            width: double.infinity,
            child: Wrap(
              children: selectedChoices.map((item) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Chip(
                    label: Text(widget.labelField != ""
                        ? item[widget.labelField]
                        : item),
                    onDeleted: () {
                      int index = selectedChoices.indexOf(item);

                      setState(() {
                        selectedChoices.removeAt(index);
                        widget.onSelectionChanged(selectedChoices);
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
