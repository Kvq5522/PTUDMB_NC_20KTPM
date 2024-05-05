import "package:flutter/material.dart";

class FileUploadFormField extends FormField<String> {
  final String uploadFile;
  final String loadedFile;
  final String name;
  final Future<void> Function() uploadFileFunc;
  final Future<void> Function() downloadFileFunc;
  final Function() removeUploadFile;

  FileUploadFormField({
    super.key,
    required this.uploadFile,
    required this.loadedFile,
    required this.name,
    required this.uploadFileFunc,
    required this.downloadFileFunc,
    required this.removeUploadFile,
    required FormFieldSetter<String>? onSaved,
    required FormFieldValidator<String>? validator,
    String super.initialValue = '',
    bool autovalidateMode = false,
  }) : super(
          onSaved: onSaved,
          validator: (value) {
            return validator!([loadedFile, uploadFile].join(','));
          },
          autovalidateMode: autovalidateMode
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          builder: (FormFieldState<String> state) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await uploadFileFunc();
                      state.didChange(uploadFile);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      side: const BorderSide(
                        color: Color.fromARGB(255, 215, 215, 215),
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      fixedSize: const Size.fromHeight(80),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      alignment: Alignment.center,
                      child: uploadFile.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '${uploadFile.split('/').last}',
                                  style: TextStyle(
                                    color: loadedFile.isNotEmpty
                                        ? Colors.black
                                        : null,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  onPressed: removeUploadFile,
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Color(0xFF008ABD),
                                  ),
                                ),
                              ],
                            )
                          : loadedFile.isNotEmpty
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '${loadedFile.split('/').last}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await downloadFileFunc();
                                      },
                                      icon: const Icon(
                                        Icons.download,
                                        color: Color(0xFF008ABD),
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Upload your $name',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                    ),
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
              ),
            );
          },
        );
}
