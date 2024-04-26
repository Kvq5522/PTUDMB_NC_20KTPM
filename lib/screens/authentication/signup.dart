// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/formfields/checkbox_formfield.dart';
import 'package:studenthub/services/auth.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:studenthub/utils/toast.dart';
import '../../app_routes.dart';
import '../../components/appbars/appbar_auth.dart';

class SignUpScreen extends StatelessWidget {
  final String selectedOption;

  const SignUpScreen({super.key, required this.selectedOption});

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
              routerConfig.pushReplacement(
                '/signup',
                extra: selectedOption == 'student' ? 'company' : 'student',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF008ABD),
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
  final AuthenticationService _authService = AuthenticationService();
  bool _isLoading = false;
  String? _errorMessage;

  late UserInfoStore _userInfoStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);
  }

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
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }

                return null;
              },
              decoration: InputDecoration(
                labelText: 'Full Name',
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
              controller: _emailController,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                } else {
                  return null;
                }
              },
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
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                } else if (!RegExp(
                        r'((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$')
                    .hasMatch(value)) {
                  return 'Password must contain at least one upper case letter, one lower case letter';
                }
              },
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
            // Row(
            //   children: [
            //     Checkbox(
            //       value: _agreeToTerms,
            //       onChanged: (newValue) {
            //         setState(() {
            //           _agreeToTerms = newValue!;
            //         });
            //       },
            //       activeColor: const Color(0xFF008ABD),
            //     ),
            //     Flexible(
            //       child: Text(
            //         'Yes, I understand and agree to Student Hub',
            //         style: TextStyle(fontSize: 15, color: Colors.black),
            //       ),
            //     ),
            //   ],
            // ),
            CheckboxFormField(
              title: Text(
                "Yes, I understand and agree to Student Hub",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              onSaved: (value) {},
              validator: (value) {
                if (value == false) {
                  return 'You must agree to the terms';
                }
                return null;
              },
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Form is validated and terms are agreed upon, process sign up
                  // Your sign up logic here
                  try {
                    setState(() {
                      _isLoading = true;
                      _errorMessage = null;
                    });

                    bool isSignupSuccess = await _authService.signUp(
                      _fullNameController.text,
                      _emailController.text,
                      _passwordController.text,
                      widget.selectedOption == 'student',
                    );

                    if (!isSignupSuccess) {
                      throw Exception('Sign up failed, please try again.');
                    }

                    if (mounted) {
                      showSuccessToast(
                          context: context,
                          message:
                              "Please check your email to verify your account.");
                    }

                    _userInfoStore.setUserType(
                        widget.selectedOption == 'student'
                            ? 'Student'
                            : 'Company');

                    routerConfig.go('/login');
                  } catch (e) {
                    setState(() {
                      _errorMessage = e.toString();
                    });
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008ABD),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text('Sign Up',
                        style: TextStyle(fontSize: 18.0, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
