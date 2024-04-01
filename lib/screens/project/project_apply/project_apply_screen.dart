import "package:flutter/material.dart";
import "package:studenthub/app_routes.dart";
import "package:studenthub/components/app_bar.dart";
import "package:studenthub/components/input_field.dart";

class ProjectApplyScreen extends StatelessWidget {
  ProjectApplyScreen({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Cover letter",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text("Describe why do you fit for this project"),
            const SizedBox(
              height: 10,
            ),
            InputField(
              controller: controller,
              bigField: true,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    routerConfig.pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    routerConfig.go("/project");
                  },
                  child: const Text(
                    "Apply",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
