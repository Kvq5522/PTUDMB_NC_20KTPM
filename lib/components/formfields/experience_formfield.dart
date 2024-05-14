import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/components/tile/project_tile.dart';

class ExperienceFormField extends FormField<List<Map<String, dynamic>>> {
  final List<Map<String, dynamic>> loadedExperience;
  final List<Map<String, dynamic>> loadedSkillSet;
  final Function({dynamic value, bool isEdited, int index}) showProjectModal;
  final Function(int) onDelete;

  ExperienceFormField({
    Key? key,
    required this.loadedExperience,
    required this.loadedSkillSet,
    required this.showProjectModal,
    required this.onDelete,
    required FormFieldSetter<List<Map<String, dynamic>>>? onSaved,
    required FormFieldValidator<List<Map<String, dynamic>>>? validator,
    List<Map<String, dynamic>>? initialValue,
    bool autovalidate = false,
  }) : super(
          onSaved: onSaved,
          validator: (value) {
            return validator!([...loadedExperience]);
          },
          initialValue: initialValue,
          autovalidateMode: autovalidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          builder: (FormFieldState<List<Map<String, dynamic>>> state) {
            return Column(
              children: [
                Column(
                  children: loadedExperience.isNotEmpty
                      ? List.generate(loadedExperience.length, (index) {
                          return ProjectTile(
                            project: loadedExperience[index],
                            skillsets: loadedSkillSet,
                            onEdit: () {
                              showProjectModal(
                                value: loadedExperience![index],
                                isEdited: true,
                                index: index,
                              );
                            },
                            onDeleted: () {
                              onDelete(index);
                            },
                          );
                        })
                      : [
                          Center(
                              child: Text(
                            "You have not added any experience yet.".tr(),
                            style: const TextStyle(
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
