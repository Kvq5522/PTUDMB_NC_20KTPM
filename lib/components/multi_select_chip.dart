import 'package:flutter/material.dart';
import 'package:studenthub/utils/string.dart';

class MultiSelectChip extends FormField<List<dynamic>> {
  final List<dynamic> itemList;
  final String valueField;
  final String labelField;
  final bool isEditable;
  final Function(List<dynamic>) onSelectionChanged;
  final Function(dynamic) onAddItem;
  final List<dynamic> selectedChoices;
  final bool isExpanded;

  MultiSelectChip({
    required this.itemList,
    this.valueField = "",
    this.labelField = "",
    this.isEditable = false,
    this.isExpanded = true,
    required this.onSelectionChanged,
    required this.selectedChoices,
    required this.onAddItem,
    required FormFieldSetter<List<dynamic>> onSaved,
    required FormFieldValidator<List<dynamic>> validator,
    List<dynamic>? initialValue,
    bool autovalidate = false,
  }) : super(
          onSaved: onSaved,
          validator: (value) {
            return validator([...selectedChoices]);
          },
          initialValue: initialValue ?? [],
          builder: (FormFieldState<List<dynamic>> state) {
            return Column(
              children: [
                _MultiSelectChipImpl(
                  itemList: itemList,
                  valueField: valueField,
                  labelField: labelField,
                  isEditable: isEditable,
                  onSelectionChanged: onSelectionChanged,
                  selectedChoices: selectedChoices,
                  onAddItem: onAddItem,
                  isExpanded: isExpanded,
                ),
                if (state.errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        state.errorText!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}

class _MultiSelectChipImpl extends StatefulWidget {
  final List<dynamic> itemList;
  final List<dynamic> selectedChoices;
  final String valueField;
  final String labelField;
  final bool isEditable;
  final bool isExpanded;
  final Function(List<dynamic>) onSelectionChanged;
  final Function(dynamic) onAddItem;

  //Need to pass value and label field simultaneously to get the value and label from the list
  //If valueField and labelField is empty, it will return the item itself
  const _MultiSelectChipImpl({
    super.key,
    required this.itemList,
    required this.isExpanded,
    this.selectedChoices = const [],
    required this.onAddItem,
    required this.valueField,
    required this.labelField,
    required this.isEditable,
    required this.onSelectionChanged,
  });
  State<_MultiSelectChipImpl> createState() => _MultiSelectChipImplState();
}

class _MultiSelectChipImplState extends State<_MultiSelectChipImpl> {
  List<dynamic> selectedChoices = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedChoices = List.from(widget.selectedChoices);
    });
  }

  void showAddItemSheet() async {
    TextEditingController textEditingController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: AlertDialog(
                  title: Text(
                      'Add New ${widget.labelField != "" ? capitalize(widget.labelField) : 'Item'}'),
                  content: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: textEditingController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter item';
                            } else if (widget.itemList
                                    .map((e) => e.toString().toLowerCase())
                                    .contains(value.toLowerCase()) ||
                                (widget.labelField != "" &&
                                    widget.itemList.any((element) =>
                                        element[widget.labelField]
                                            .toString()
                                            .toLowerCase() ==
                                        value.toLowerCase()))) {
                              return 'Item already exists';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: widget.labelField != ""
                                ? capitalize(widget.labelField)
                                : 'Item',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  widget.onAddItem(
                                    textEditingController.text,
                                  );

                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  void didUpdateWidget(_MultiSelectChipImpl oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      selectedChoices = List.from(widget.selectedChoices);
    });
  }

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          //Create dropdown button for itemlist
          widget.isEditable
              ? SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DropdownMenu(
                          controller: _textEditingController,
                          width: MediaQuery.of(context).size.width *
                              (widget.isExpanded ? 0.75 : 0.5),
                          menuHeight: 200.0,
                          requestFocusOnTap: true,
                          initialSelection: widget.itemList.isNotEmpty
                              ? widget.itemList[0]
                              : "",
                          label: Text(widget.labelField != ""
                              ? capitalize(widget.labelField)
                              : "Select item"),
                          dropdownMenuEntries: widget.itemList
                              .map<DropdownMenuEntry<dynamic>>((item) {
                            return DropdownMenuEntry<dynamic>(
                                value: widget.valueField != ""
                                    ? item[widget.valueField]
                                    : item,
                                label: widget.labelField != ""
                                    ? item[widget.labelField]
                                    : item);
                          }).toList(),
                          onSelected: (value) => {
                            setState(() {
                              bool valueNotInSelectedChoice = true;

                              for (var i = 0; i < selectedChoices.length; i++) {
                                if (selectedChoices[i] == value ||
                                    (widget.labelField != "" &&
                                        selectedChoices[i][widget.labelField] ==
                                            value[widget.labelField])) {
                                  valueNotInSelectedChoice = false;
                                  break;
                                }
                              }

                              if (valueNotInSelectedChoice && value != null) {
                                selectedChoices.add(widget.valueField != ""
                                    ? {
                                        widget.valueField: value,
                                      }
                                    : value);
                                widget.onSelectionChanged(selectedChoices);
                              }
                            })
                          },
                        ),
                      ),
                      widget.isEditable
                          ? IconButton(
                              onPressed: () {
                                if (widget.isEditable) {
                                  showAddItemSheet();
                                }
                              },
                              icon: const Icon(
                                Icons.add_circle_rounded,
                                color: Color(0xFF008ABD),
                              ),
                              tooltip: "Add new item",
                            )
                          : const SizedBox()
                    ],
                  ),
                )
              : const SizedBox(),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              children: selectedChoices.map((item) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Chip(
                    label: Text(widget.labelField != ""
                        ? item[widget.labelField].toString()
                        : item.toString()),
                    deleteIconColor: const Color(0xFF008ABD),
                    deleteIcon: widget.isEditable
                        ? Transform.translate(
                            offset: const Offset(
                                0, -2), // Adjust the offset as needed
                            child: const Icon(
                              Icons.cancel,
                              color: Color(0xFF008ABD),
                            ),
                          )
                        : const SizedBox(),
                    onDeleted: () {
                      if (widget.isEditable) {
                        selectedChoices.remove(item);
                        widget.onSelectionChanged(selectedChoices);
                      }
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
