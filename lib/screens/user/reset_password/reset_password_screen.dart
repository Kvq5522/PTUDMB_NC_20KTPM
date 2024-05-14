// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/appbars/appbar_setting.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:studenthub/services/user.service.dart';
import 'package:studenthub/utils/toast.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isNewPasswordVisible = true;
  bool _isConfirmPasswordVisible = false;

  late UserInfoStore _userInfoStore;
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SettingAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Old password'.tr()),
                TextFormField(
                  controller: _oldPasswordController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Old password is required'.tr();
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF008ABD)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    prefixIcon: const Icon(Icons.lock_open_rounded,
                        color: Colors.black),
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                  ),
                  style: const TextStyle(color: Colors.black),
                  cursorColor: const Color(0xFF008ABD),
                ),
                const SizedBox(height: 10.0),
                Text('New password'.tr()),
                TextFormField(
                  controller: _newPasswordController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'New password is required'.tr();
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long'.tr();
                    } else if (value == _oldPasswordController.text) {
                      return 'New password must be different from old password'
                          .tr();
                    } else {
                      return null;
                    }
                  },
                  obscureText: !_isNewPasswordVisible,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF008ABD)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                        color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isNewPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _isNewPasswordVisible = !_isNewPasswordVisible;
                        });
                      },
                    ),
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                  ),
                  style: const TextStyle(color: Colors.black),
                  cursorColor: const Color(0xFF008ABD),
                ),
                const SizedBox(height: 10.0),
                Text('Confirm new password'.tr()),
                TextFormField(
                  controller: _confirmPasswordController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Confirmation password is required'.tr();
                    } else if (value != _newPasswordController.text) {
                      return 'Passwords do not match'.tr();
                    } else {
                      return null;
                    }
                  },
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF008ABD)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                        color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                  ),
                  style: const TextStyle(color: Colors.black),
                  cursorColor: const Color(0xFF008ABD),
                ),
                const SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && !_isLoading) {
                      try {
                        setState(() {
                          _isLoading = true;
                          _errorMessage = null;
                        });

                        String resetPassword =
                            await _userService.changePassword(
                          oldPassword: _oldPasswordController.text,
                          newPassword: _newPasswordController.text,
                          token: _userInfoStore.token,
                        );

                        _oldPasswordController.clear();
                        _newPasswordController.clear();
                        _confirmPasswordController.clear();

                        showSuccessToast(
                            context: context, message: resetPassword);
                      } catch (e) {
                        setState(() {
                          _errorMessage = e.toString();
                        });

                        showDangerToast(
                            context: context,
                            message:
                                "Cant reset password. Please try again later."
                                    .tr());
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008ABD),
                    elevation: 3,
                  ),
                  child: _isLoading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Reset password'.tr(),
                            style: const TextStyle(
                                fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
