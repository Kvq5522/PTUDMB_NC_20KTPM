import "package:flutter/material.dart";
import "package:intl/intl.dart";

class DateTimeFormField extends FormField<DateTime> {
  final BuildContext context;

  DateTimeFormField({
    required this.context,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
    DateTime? initialValue,
    bool autovalidate = false,
  }) : super(
          onSaved: onSaved,
          validator: validator,
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
                  lastDate: DateTime.now(),
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
