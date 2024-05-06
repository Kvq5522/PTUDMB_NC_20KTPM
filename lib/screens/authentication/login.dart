// ignore_for_file: sized_box_for_whitespace

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/services/auth.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import '../../app_routes.dart';
import '../../components/appbars/appbar_auth.dart';
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.125),
            Text(
              "Sign In".tr(),
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                shadows: [
                  Shadow(
                    color: Colors.grey.withOpacity(0.5), // shadow color
                    offset: Offset(1.0, 1.0), // changes position of shadow
                    blurRadius: 1.0, // how blurry you want the shadow
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            LoginForm(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        color: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Don't have a Student Hub account?".tr(),
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                routerConfig.pushReplacement('/signup_options');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008ABD),
              ),
              child:
                  Text('Sign Up'.tr(), style: TextStyle(color: Colors.white)),
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
            SizedBox(height: 18.0),
            Text('Email'),
            TextFormField(
              controller: _emailController,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Email is required';
                } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFF008ABD)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                prefixIcon: Icon(Icons.email_outlined, color: Colors.black),
                fillColor: Colors
                    .grey[200], // Add a background color for better contrast
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0), // Adjust padding as needed
              ),
              style: TextStyle(color: Colors.black),
              cursorColor: const Color(0xFF008ABD),
            ),
            SizedBox(height: 20.0),
            Text('Password'),
            TextFormField(
              controller: _passwordController,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFF008ABD)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                prefixIcon: Icon(Icons.lock_outline, color: Colors.black),
                fillColor: Colors
                    .grey[200], // Add a background color for better contrast
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0), // Adjust padding as needed
              ),
              obscureText: true,
              style: TextStyle(color: Colors.black),
              cursorColor: const Color(0xFF008ABD),
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() && !_isLoading) {
                  // Form is validated, process login
                  // Your login logic here
                  try {
                    setState(() {
                      _isLoading = true;
                      _errorMessage = null;
                    });

                    String token = await _authService.signIn(
                        _emailController.text, _passwordController.text);

                    Map<String, dynamic> userInfo =
                        await _authService.getUserInfo(token);

                    FlutterBackgroundService().invoke("setAsBackground", {
                      "token": token,
                      "userId": userInfo['id'].toString(),
                    });

                    _userInfoStore.setToken(token);
                    _userInfoStore.setUserId(BigInt.from(userInfo['id']));

                    routerConfig.go('/choose-user');
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
                elevation: 3,
              ),
              child: _isLoading
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Login'.tr(),
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
