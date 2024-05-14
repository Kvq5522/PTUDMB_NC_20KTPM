import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/components/formfields/datetime_formfield.dart';
import 'package:studenthub/utils/string.dart';
import 'package:studenthub/utils/time.dart';

class EducationTraitFormField extends FormField<List<dynamic>> {
  final List<dynamic> educationData;
  final Function(dynamic, int) onEdit;
  final Function(int) onDelete;
  final BuildContext context;

  EducationTraitFormField({
    required this.educationData,
    required this.onEdit,
    required this.onDelete,
    required this.context,
    FormFieldSetter<List<dynamic>>? onSaved,
    FormFieldValidator<List<dynamic>>? validator,
    List<dynamic>? initialValue,
    bool autovalidate = false,
  }) : super(
          onSaved: onSaved,
          validator: (value) {
            return validator!([...educationData]);
          },
          initialValue: initialValue ?? [],
          autovalidateMode: autovalidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          builder: (FormFieldState<List<dynamic>> state) {
            return Column(children: [
              Column(
                children: educationData.isNotEmpty
                    ? educationData.map((education) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(education?["schoolName"]),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Color(0xFF008ABD),
                                      ),
                                      onPressed: () {
                                        // Handle onPressed for editing education
                                        var formKey = GlobalKey<FormState>();
                                        TextEditingController
                                            educationController =
                                            TextEditingController();
                                        educationController.text =
                                            education?["schoolName"];
                                        DateTime from = education?["startYear"]
                                                is int
                                            ? DateTime(education?["startYear"])
                                            : DateTime.parse(
                                                education?["startYear"]);
                                        DateTime to = education?["endYear"]
                                                is int
                                            ? DateTime(education?["endYear"])
                                            : DateTime.parse(
                                                education?["endYear"]);

                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Center(
                                              child: IntrinsicWidth(
                                                child: IntrinsicHeight(
                                                  child: AlertDialog(
                                                    title: Text(
                                                        "Add Education".tr()),
                                                    content: Form(
                                                      key: formKey,
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize
                                                            .min, // This makes the column fit its content
                                                        children: [
                                                          TextFormField(
                                                            validator: (String?
                                                                value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return "Please type proper education"
                                                                    .tr();
                                                              } else if (educationData.any((element) =>
                                                                  element['schoolName']
                                                                          .toString()
                                                                          .toLowerCase() ==
                                                                      value
                                                                          .toLowerCase() &&
                                                                  element !=
                                                                      education)) {
                                                                return "You are already added this education"
                                                                    .tr();
                                                              }
                                                              return null;
                                                            },
                                                            controller:
                                                                educationController,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  "Enter education"
                                                                      .tr(),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Row(
                                                            children: [
                                                              // From date
                                                              Expanded(
                                                                child:
                                                                    DateTimeFormField(
                                                                  context:
                                                                      context,
                                                                  initialValue:
                                                                      from,
                                                                  onSaved:
                                                                      (value) {},
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                        null) {
                                                                      return "Please select a date"
                                                                          .tr();
                                                                    } else if (value
                                                                        .isAfter(
                                                                            to)) {
                                                                      return "From date must be before today"
                                                                          .tr();
                                                                    }

                                                                    from =
                                                                        value;

                                                                    return null;
                                                                  },
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 20),
                                                              // To date
                                                              Expanded(
                                                                child:
                                                                    DateTimeFormField(
                                                                  context:
                                                                      context,
                                                                  initialValue:
                                                                      to,
                                                                  onSaved:
                                                                      (value) {},
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                        null) {
                                                                      return 'Please select a date'
                                                                          .tr();
                                                                    } else if (from
                                                                        .isAfter(
                                                                            value)) {
                                                                      return 'From date must be before to date'
                                                                          .tr();
                                                                    }

                                                                    to = value;

                                                                    return null;
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          // Close the dialog
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            Text('Cancel'.tr()),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          // Handle adding the language
                                                          // Close the dialog
                                                          if (formKey
                                                              .currentState!
                                                              .validate()) {
                                                            onEdit(
                                                                {
                                                                  "schoolName":
                                                                      capitalize(
                                                                          educationController
                                                                              .text),
                                                                  "startYear": from
                                                                      .toString(),
                                                                  "endYear": to
                                                                      .toString()
                                                                },
                                                                educationData
                                                                    .indexOf(
                                                                        education));
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }
                                                        },
                                                        child:
                                                            Text('Edit'.tr()),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Color(0xFF008ABD),
                                      ),
                                      onPressed: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Delete Education'.tr()),
                                                content: Text(
                                                    'Are you sure you want to delete this education?'
                                                        .tr()),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.blue,
                                                      foregroundColor:
                                                          Colors.white,
                                                      textStyle:
                                                          const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    child: Text('Cancel'.tr()),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      onDelete(educationData
                                                          .indexOf(education));
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.blue,
                                                      foregroundColor:
                                                          Colors.white,
                                                      textStyle:
                                                          const TextStyle(
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
                            ),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '${formatYear(education?["startYear"])} - ${formatYear(education?["endYear"])}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        );
                      }).toList()
                    : [
                        Center(
                          child: Text(
                            "You have not added any education yet.".tr(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                          ),
                        )
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
            ]);
          },
        );
}
