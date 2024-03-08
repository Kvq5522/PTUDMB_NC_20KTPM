// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import '../../app_routes.dart';
import '../../components/appbar_auth.dart';
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Auth_AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Text(
              "Join as company or student",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            LoginForm(),
          ],
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
              "Don't have a Student Hub account?",
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                routerConfig.pushReplacement('/signup_options');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008ABD),
              ),
              child: Text('Sign Up', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFF008ABD)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: TextStyle(color: Colors.black),
              cursorColor: const Color(0xFF008ABD),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFF008ABD)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              obscureText: true,
              style: TextStyle(color: Colors.black),
              cursorColor: const Color(0xFF008ABD),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // if (_formKey.currentState!.validate()) {
                //   // Form is validated, process login
                //   // Your login logic here
                // }
                routerConfig.pushReplacement('/choose-user');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008ABD),
              ),
              child: Text('Sign In',
                  style: TextStyle(fontSize: 18.0, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}