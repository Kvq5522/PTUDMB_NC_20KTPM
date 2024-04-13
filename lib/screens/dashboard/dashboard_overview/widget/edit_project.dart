// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables

import "package:flutter/material.dart";
import "package:studenthub/app_routes.dart";
import "package:studenthub/services/dashboard.service.dart";

class EditProjectDialog extends StatefulWidget {
  final Map<String, dynamic>? projectInfo;
  final token;
  const EditProjectDialog(
      {super.key, required this.projectInfo, required this.token});

  @override
  _EditProjectDialogState createState() => _EditProjectDialogState();
}

class _EditProjectDialogState extends State<EditProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  int _projectScopeFlag = 0;
  String _title = '';
  int _numberOfStudents = 0;
  String _description = '';
  int _typeFlag = 0;
  final DashBoardService _dashBoardService = DashBoardService();
  @override
  void initState() {
    super.initState();
    if (widget.projectInfo != null) {
      _projectScopeFlag = widget.projectInfo?['projectScopeFlag'] ?? 0;
      _title = widget.projectInfo?['title'] ?? '';
      _numberOfStudents = widget.projectInfo?['numberOfStudents'] ?? 0;
      _description = widget.projectInfo?['description'] ?? '';
      _typeFlag = widget.projectInfo?['typeFlag'] ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Project', style: TextStyle(color: Colors.black)),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButtonFormField<int>(
                itemHeight: null,
                decoration: InputDecoration(
                  labelText: 'Project time',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a project time';
                  }
                  return null;
                },
                onSaved: (value) {
                  _projectScopeFlag = value!;
                },
                onChanged: (value) {
                  setState(() {
                    _projectScopeFlag = value!;
                  });
                },
                items: [
                  DropdownMenuItem<int>(
                    value: 1,
                    child: Text('1-3 Months'),
                  ),
                  DropdownMenuItem<int>(
                    value: 2,
                    child: Text('3-6 Months'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                  hintText: 'Enter project title',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _numberOfStudents.toString(),
                decoration: InputDecoration(
                  labelText: 'Number of Students',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                  hintText: 'Enter number of students',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of students';
                  }
                  return null;
                },
                onSaved: (value) {
                  _numberOfStudents = int.parse(value!);
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                  hintText: 'Enter project description',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                // value: _typeFlag,
                decoration: InputDecoration(
                  labelText: 'Project status',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select project status';
                  }
                  return null;
                },
                onSaved: (value) {
                  _typeFlag = value!;
                },
                onChanged: (value) {
                  setState(() {
                    _typeFlag = value!;
                  });
                },
                items: [
                  DropdownMenuItem<int>(
                    value: 0,
                    child: Text('Working'),
                  ),
                  DropdownMenuItem<int>(
                    value: 1,
                    child: Text('Archived'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel', style: TextStyle(color: Colors.black)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Save', style: TextStyle(color: Colors.black)),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              try {
                await _dashBoardService.patchProjectDetails(
                  widget.projectInfo?['id'],
                  _projectScopeFlag,
                  _title,
                  _description,
                  _numberOfStudents,
                  _typeFlag,
                  widget.token,
                );

                routerConfig.push('/dashboard');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}