import "package:flutter/material.dart";
import "package:studenthub/constants/language_mock.dart";
import "package:studenthub/utils/string.dart";

class LanguageTraitFormField extends FormField<List<dynamic>> {
  final List<dynamic> languageData;
  final String labelField;
  final Function(String, int) onEdit;
  final Function(int) onDelete;
  final BuildContext context;

  LanguageTraitFormField({
    super.key,
    required this.languageData,
    this.labelField = "",
    required this.context,
    required FormFieldSetter<List<dynamic>>? onSaved,
    required FormFieldValidator<List<dynamic>>? validator,
    required this.onEdit,
    required this.onDelete,
    List<String>? initialValue,
    bool autovalidate = false,
  }) : super(
          onSaved: onSaved,
          validator: (value) {
            return validator!([...languageData]);
          },
          initialValue: initialValue ?? [],
          autovalidateMode: autovalidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          builder: (FormFieldState<List<dynamic>> state) {
            return Column(
              children: [
                Column(
                  children: languageData.isNotEmpty
                      ? languageData.map<Widget>((language) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(labelField.isNotEmpty
                                  ? language[labelField]
                                  : language.toString()),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      var formKey = GlobalKey<FormState>();
                                      TextEditingController languageController =
                                          TextEditingController();
                                      languageController.text =
                                          language?['languageName'] ?? "";

                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Add Language'),
                                            content: Form(
                                              key: formKey,
                                              child: TextFormField(
                                                validator: (String? value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please type proper language';
                                                  } else if (languageData.any(
                                                      (element) =>
                                                          element['languageName']
                                                              .toString()
                                                              .toLowerCase() ==
                                                          value
                                                              .toLowerCase())) {
                                                    return 'You are already added this language';
                                                  }
                                                  return null;
                                                },
                                                controller: languageController,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Enter language',
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Close the dialog
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Handle adding the language
                                                  // Close the dialog
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    onEdit(
                                                        languageController.text,
                                                        languageData
                                                            .indexOf(language));
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                child: const Text('Edit'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Delete Education'),
                                              content: const Text(
                                                  'Are you sure you want to delete this education?'),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    onDelete(languageData
                                                        .indexOf(language));
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        }).toList()
                      : [
                          const Center(
                              child: Text(
                            "You have not added any language yet.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                          ))
                        ],
                ),
                if (state.errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        state.errorText!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}
