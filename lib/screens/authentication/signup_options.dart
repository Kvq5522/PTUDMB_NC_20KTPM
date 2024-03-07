// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../../app_routes.dart';
import '../../components/appbar_auth.dart';

class SignUpOptions extends StatefulWidget {
  const SignUpOptions({super.key});

  @override
  _SignUpOptionsState createState() => _SignUpOptionsState();
}

class _SignUpOptionsState extends State<SignUpOptions> {
  String selectedOption = '';
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Auth_AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Join as company or student",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: RadioListTile(
                    title: Row(
                      children: [
                        Icon(Icons.business),
                        SizedBox(width: 10),
                        Text('I am a company'),
                      ],
                    ),
                    value: 'company',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value as String;
                      });
                    },
                    selected: selectedOption == 'company',
                    controlAffinity: ListTileControlAffinity.trailing,
                    tileColor: selectedOption == 'company'
                        ? const Color(0xFF008ABD).withOpacity(0.1)
                        : null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    activeColor: const Color(0xFF008ABD),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: RadioListTile(
                    title: Row(
                      children: [
                        Icon(Icons.school),
                        SizedBox(width: 10),
                        Text('I am a student'),
                      ],
                    ),
                    value: 'student',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value as String;
                      });
                    },
                    selected: selectedOption == 'student',
                    controlAffinity: ListTileControlAffinity.trailing,
                    tileColor: selectedOption == 'student'
                        ? const Color(0xFF008ABD).withOpacity(0.1)
                        : null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    activeColor: const Color(0xFF008ABD),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (selectedOption.isNotEmpty) {
                    // Navigator.pushNamed(
                    //   context,
                    //   '/signup',
                    //   arguments: selectedOption,
                    // );
                    routerConfig.pushReplacement(
                      '/signup',
                      extra: selectedOption,
                    );
                    setState(() {
                      errorMessage = '';
                    });
                  } else {
                    setState(() {
                      errorMessage = "Please select an option";
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008ABD),
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
                ),
                child: Text('Create account',
                    style: TextStyle(fontSize: 18.0, color: Colors.white)),
              ),
              errorMessage.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Already have an account ?",
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                routerConfig.pushReplacement('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008ABD),
              ),
              child: Text('Log In', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  AppBar bar() {
    return AppBar(
      title: Text('Student Hub'),
      actions: [
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            //when click on profile icon
          },
        ),
      ],
    );
  }
}
