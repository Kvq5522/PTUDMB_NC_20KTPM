import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddInterviewDialog extends StatefulWidget {
  final Function(String title, int startTime, int endTime) onInterviewCreated;

  const AddInterviewDialog({Key? key, required this.onInterviewCreated})
      : super(key: key);

  @override
  _AddInterviewDialogState createState() => _AddInterviewDialogState();
}

class _AddInterviewDialogState extends State<AddInterviewDialog> {
  late String _title;
  late DateTime _selectedStartDate;
  late DateTime _selectedEndDate;

  @override
  void initState() {
    super.initState();
    _title = '';
    _selectedStartDate = DateTime.now();
    _selectedEndDate = DateTime.now().add(Duration(hours: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Add Interview",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 20.0),
          TextField(
            decoration: InputDecoration(labelText: "Title"),
            onChanged: (value) {
              setState(() {
                _title = value;
              });
            },
          ),
          SizedBox(height: 20.0),
          ListTile(
            title: Text(
              "Start Time: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedStartDate)}",
            ),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedStartDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                final TimeOfDay? timePicked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_selectedStartDate),
                );
                if (timePicked != null) {
                  setState(() {
                    _selectedStartDate = DateTime(
                      picked.year,
                      picked.month,
                      picked.day,
                      timePicked.hour,
                      timePicked.minute,
                    );
                  });
                }
              }
            },
          ),
          ListTile(
            title: Text(
              "End Time: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedEndDate)}",
            ),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedEndDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                final TimeOfDay? timePicked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_selectedEndDate),
                );
                if (timePicked != null) {
                  setState(() {
                    _selectedEndDate = DateTime(
                      picked.year,
                      picked.month,
                      picked.day,
                      timePicked.hour,
                      timePicked.minute,
                    );
                  });
                }
              }
            },
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Create"),
                onPressed: () {
                  if (_title.isNotEmpty) {
                    int startTimestamp =
                        _selectedStartDate.millisecondsSinceEpoch ~/ 1000;
                    int endTimestamp =
                        _selectedEndDate.millisecondsSinceEpoch ~/ 1000;

                    widget.onInterviewCreated(
                        _title, startTimestamp, endTimestamp);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
