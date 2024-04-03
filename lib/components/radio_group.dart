import 'package:flutter/material.dart';

class RadioGroup extends StatefulWidget {
  final Map<String, int> items;
  final ValueChanged onChanged;
  final int initialValue;

  const RadioGroup({
    super.key,
    required this.items,
    required this.onChanged,
    required this.initialValue,
  });

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  late int _selectedItem;

  @override
  void initState() {
    print(widget.initialValue);
    super.initState();
    _selectedItem = widget.initialValue;
  }

  @override
  void didChangeDependencies() {
    print(widget.initialValue);

    super.didChangeDependencies();
    _selectedItem = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.items.keys.map((String key) {
          return RadioListTile(
            title: Text(key),
            value: widget.items[key]!,
            groupValue: _selectedItem,
            onChanged: (value) {
              setState(() {
                _selectedItem = value!;
              });
              widget.onChanged(value!);
            },
            activeColor: const Color(0xFF008ABD),
          );
        }).toList(),
      ),
    );
  }
}
