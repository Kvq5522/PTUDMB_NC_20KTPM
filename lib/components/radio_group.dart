import 'package:flutter/material.dart';

class RadioGroup extends StatefulWidget {
  final Map<String, int> companySize;
  final ValueChanged onChanged;

  const RadioGroup({
    Key? key,
    required this.companySize,
    required this.onChanged,
  }) : super(key: key);

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  int _selectedSize = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.companySize.keys.map((String key) {
        return RadioListTile(
          title: Text(key),
          value: widget.companySize[key]!,
          groupValue: _selectedSize,
          onChanged: (value) {
            setState(() {
              _selectedSize = value!;
            });
            widget.onChanged(value!);
          },
        );
      }).toList(),
    );
  }
}
