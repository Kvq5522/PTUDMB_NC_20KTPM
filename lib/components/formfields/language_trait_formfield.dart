import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";

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
    required super.onSaved,
    required FormFieldValidator<List<dynamic>>? validator,
    required this.onEdit,
    required this.onDelete,
    List<String>? initialValue,
    bool autovalidate = false,
  }) : super(
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
                                    icon: const Icon(Icons.edit,
                                        color: Color(0xFF008ABD)),
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
                                            title: Text('Add Language'.tr()),
                                            content: Form(
                                              key: formKey,
                                              child: TextFormField(
                                                validator: (String? value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please type proper language'
                                                        .tr();
                                                  } else if (languageData.any(
                                                      (element) =>
                                                          element['languageName']
                                                              .toString()
                                                              .toLowerCase() ==
                                                          value
                                                              .toLowerCase())) {
                                                    return 'You are already added this language'
                                                        .tr();
                                                  }
                                                  return null;
                                                },
                                                controller: languageController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Enter language'.tr(),
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Close the dialog
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Cancel'.tr()),
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
                                                child: Text('Edit'.tr()),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Color(0xFF008ABD)),
                                    onPressed: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  Text('Delete Language'.tr()),
                                              content: Text(
                                                  'Are you sure you want to delete this language?'
                                                      .tr()),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blue,
                                                    foregroundColor:
                                                        Colors.white,
                                                    textStyle: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  child: Text('Cancel'.tr()),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    onDelete(languageData
                                                        .indexOf(language));
                                                    Navigator.of(context).pop();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blue,
                                                    foregroundColor:
                                                        Colors.white,
                                                    textStyle: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  child: Text('Delete'.tr()),
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
