// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../app_routes.dart';

class SignUpScreen extends StatelessWidget {
  final String selectedOption;

  const SignUpScreen({super.key, required this.selectedOption});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: bar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Text(
              selectedOption == "student"
                  ? "Sign up as student"
                  : "Sign up as company",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SignUpForm(selectedOption: selectedOption),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
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

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedOption == "student"
                ? "Are you a company?"
                : "Looking for a project?",
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              routerConfig.push(
                '/signup',
                extra: selectedOption == 'student' ? 'company' : 'student',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: Text(
              selectedOption == "student"
                  ? 'Apply as company'
                  : 'Apply as student',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  final String selectedOption;

  const SignUpForm({super.key, required this.selectedOption});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: TextStyle(color: Colors.black),
              cursorColor: Colors.blue,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: TextStyle(color: Colors.black),
              cursorColor: Colors.blue,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              obscureText: true,
              style: TextStyle(color: Colors.black),
              cursorColor: Colors.blue,
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (newValue) {
                    setState(() {
                      _agreeToTerms = newValue!;
                    });
                  },
                  activeColor: Colors.blue,
                ),
                Flexible(
                  child: Text(
                    'Yes, I understand and agree to studentHub',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && _agreeToTerms) {
                  // Form is validated and terms are agreed upon, process sign up
                  // Your sign up logic here
                } else {
                  // Show error message or handle case where terms are not agreed upon
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text('Sign Up',
                  style: TextStyle(fontSize: 18.0, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
