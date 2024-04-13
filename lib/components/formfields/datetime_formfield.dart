import "package:flutter/material.dart";
import "package:intl/intl.dart";

class DateTimeFormField extends FormField<DateTime> {
  final BuildContext context;

  DateTimeFormField({super.key, 
    required this.context,
    super.onSaved,
    super.validator,
    DateTime? initialValue,
    bool autovalidate = false,
  }) : super(
          initialValue: initialValue ?? DateTime.now(),
          autovalidateMode: autovalidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          builder: (FormFieldState<DateTime> state) {
            return InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: state.context,
                  initialDate: state.value!,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(DateTime.now().year + 10),
                );
                if (date != null) {
                  state.didChange(date);
                }
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: InputDecorator(
                  decoration: InputDecoration(
                    errorText: state.errorText,
                  ),
                  child: Text(
                    DateFormat.yMMMd().format(state.value!),
                  ),
                ),
              ),
            );
          },
        );
}
