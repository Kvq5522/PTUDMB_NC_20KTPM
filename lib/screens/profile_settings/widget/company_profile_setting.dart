import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/components/loading_screen.dart';
import 'package:studenthub/components/radio_group.dart';
import 'package:studenthub/services/user.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:studenthub/utils/toast.dart';

class CompanyProfileSetting extends StatefulWidget {
  const CompanyProfileSetting({super.key});

  @override
  State<CompanyProfileSetting> createState() => _CompanyProfileSettingState();
}

class _CompanyProfileSettingState extends State<CompanyProfileSetting> {
  final companySize = {
    "1": 0,
    "2-9": 1,
    "10-99": 2,
    "100-999": 3,
    "1000+": 4,
  };

  int _chosenCompanySize = 0;
  bool _isLoading = false;

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyWebsiteController =
      TextEditingController();
  final TextEditingController _companyDescriptionController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();

  late UserInfoStore _userInfoStore;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);

    // Get company profile if it exists
    if (_userInfoStore.hasProfile) {
      try {
        setState(() {
          _isLoading = true;
        });

        Map<String, dynamic> res = await _userService.getCompanyProfile(
            token: _userInfoStore.token, companyId: _userInfoStore.roleId);

        setState(() {
          _chosenCompanySize = res['size'];
          _companyNameController.text = res['companyName'];
          _companyWebsiteController.text = res['website'];
          _companyDescriptionController.text = res['description'];
        });
      } catch (e) {
        if (e.toString().contains("Unauthorized")) {
          _userInfoStore.reset();

          if (mounted) {
            showDangerToast(
                context: context, message: "Please sign in again.".tr());
            routerConfig.go('/login');
          }
        } else {
          print(e);
          if (mounted) {
            showDangerToast(
                context: context,
                message: "Failed to get company profile.".tr());
          }
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _isLoading
          ? const LoadingScreen()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Welcome to Student Hub".tr(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Tell us about your company and you will be on your way connect with high-skilled students."
                          .tr(),
                    ),
                    const SizedBox(height: 20),
                    Text("How many people are in your company?".tr()),
                    RadioGroup(
                      items: companySize,
                      initialValue: _chosenCompanySize,
                      onChanged: (value) {
                        setState(() {
                          _chosenCompanySize = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    //Input company name
                    Text("Company Name".tr()),
                    TextFormField(
                      controller: _companyNameController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your company name'.tr();
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Input your company name here".tr(),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF008ABD)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    //Input company website
                    Text(
                      "Company Website".tr(),
                      textAlign: TextAlign.left,
                    ),
                    TextFormField(
                      controller: _companyWebsiteController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your company website'.tr();
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Input your company website here".tr(),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF008ABD)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    //Input company description
                    Text("Company Description".tr()),
                    TextFormField(
                      controller: _companyDescriptionController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your company description'.tr();
                        }
                        return null;
                      },
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Input your company description here".tr(),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF008ABD)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    //Button to submit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              try {
                                if (_formKey.currentState!.validate() &&
                                    !_isLoading) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  Map<String, dynamic> res = await _userService
                                      .createOrUpdateCompanyProfile(
                                          token: _userInfoStore.token,
                                          companyName:
                                              _companyNameController.text,
                                          size: _chosenCompanySize,
                                          website:
                                              _companyWebsiteController.text,
                                          description:
                                              _companyDescriptionController
                                                  .text,
                                          hasProfile: _userInfoStore.hasProfile,
                                          companyId: _userInfoStore.roleId);

                                  if (res.isNotEmpty &&
                                      _userInfoStore.hasProfile) {
                                    if (mounted) {
                                      showSuccessToast(
                                          context: context,
                                          message:
                                              "Company profile updated.".tr());
                                    }
                                  } else if (res.isNotEmpty) {
                                    print("res: $res");
                                    _userInfoStore.setHasProfile(true);
                                    _userInfoStore.setRoleId(
                                        BigInt.parse(res["id"].toString()));

                                    showSuccessToast(
                                        context: context,
                                        message:
                                            "Company profile created.".tr());
                                  }

                                  routerConfig.go('/welcome',
                                      extra: res["companyName"]);
                                }
                              } catch (e) {
                                if (e.toString().contains("Unauthorized")) {
                                  _userInfoStore.reset();

                                  if (mounted) {
                                    showDangerToast(
                                        context: context,
                                        message: "Please sign in again.".tr());
                                    routerConfig.go('/login');
                                  }
                                } else {
                                  print(e);
                                  if (mounted) {
                                    showDangerToast(
                                        context: context,
                                        message:
                                            "Failed to create company profile.".tr());
                                  }
                                }
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Text("Continue".tr())),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
