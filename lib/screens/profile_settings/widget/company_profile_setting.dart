import 'package:flutter/material.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/components/input_field.dart';
import 'package:studenthub/components/radio_group.dart';

class CompanyProfileSetting extends StatefulWidget {
  const CompanyProfileSetting({super.key});

  @override
  State<CompanyProfileSetting> createState() => _CompanyProfileSettingState();
}

class _CompanyProfileSettingState extends State<CompanyProfileSetting> {
  final companySize = {
    "1": 1,
    "2-9": 9,
    "10-99": 99,
    "100-999": 999,
    "1000+": 1000,
  };

  int step = 0;
  int chosenCompanySize = 1;

  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyWebiteController = TextEditingController();
  TextEditingController companyDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Welcome to Student Hub",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Tell us about your company and you will be on your way connect with high-skilled students.",
            ),
            const SizedBox(height: 20),
            const Text("How many people are in your company?"),
            RadioGroup(
              companySize: companySize,
              onChanged: (value) {
                // Handle the selected company size
              },
            ),
            const SizedBox(height: 20),

            //Input company name
            const Text("Company Name"),
            InputField(
              controller: companyNameController,
              hintText: "Input your company name here",
            ),
            const SizedBox(height: 20),

            //Input company website
            const Text(
              "Company Website",
              textAlign: TextAlign.left,
            ),
            InputField(
              controller: companyWebiteController,
              hintText: "Input your company website here",
            ),
            const SizedBox(height: 20),

            //Input company description
            const Text("Company Description"),
            InputField(
              controller: companyDescriptionController,
              hintText: "Input your company description here",
              bigField: true,
            ),

            const SizedBox(height: 20),

            //Button to submit
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      routerConfig.push('/welcome');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text("Continue")),
              ],
            )
          ],
        ),
      ),
    );
  }
}