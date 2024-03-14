import 'package:flutter/material.dart';

class MyFillTer extends StatefulWidget {
  const MyFillTer({super.key});

  @override
  State<MyFillTer> createState() => _MyFillTerState();
}

class _MyFillTerState extends State<MyFillTer> {
  int selectedOption = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: const Color(0xFF008ABD),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Filter",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF008ABD),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Divider(
                      color: Color.fromARGB(255, 223, 223, 223),
                      height: 0.5,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Project length",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: const Text('Less than one month'),
                          leading: Radio<int>(
                            value: 1,
                            groupValue: selectedOption,
                            activeColor: Colors.blue,
                            fillColor: MaterialStateProperty.all(Colors.blue),
                            splashRadius: 25,
                            onChanged: (int? value) {
                              setState(() {
                                selectedOption = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('1 to 3 months'),
                          leading: Radio<int>(
                            value: 2,
                            groupValue: selectedOption,
                            activeColor: Colors.blue,
                            fillColor: MaterialStateProperty.all(Colors.blue),
                            splashRadius: 25,
                            onChanged: (int? value) {
                              setState(() {
                                selectedOption = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('3 to 6 months'),
                          leading: Radio<int>(
                            value: 3,
                            groupValue: selectedOption,
                            activeColor: Colors.blue,
                            fillColor: MaterialStateProperty.all(Colors.blue),
                            splashRadius: 25,
                            onChanged: (int? value) {
                              setState(() {
                                selectedOption = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('More than 6 months'),
                          leading: Radio<int>(
                            value: 4,
                            groupValue: selectedOption,
                            activeColor: Colors.blue,
                            fillColor: MaterialStateProperty.all(Colors.blue),
                            splashRadius: 25,
                            onChanged: (int? value) {
                              setState(() {
                                selectedOption = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Students needeed",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter number of students',
                        filled: true,
                        fillColor: Colors.grey[200], // Màu nền
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Độ cong viền
                          borderSide: BorderSide.none, // Không có đường viền
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14), // Khoảng cách giữa nội dung và viền
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Proposals less than",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter proposals less than',
                        filled: true,
                        fillColor: Colors.grey[200], // Màu nền
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Độ cong viền
                          borderSide: BorderSide.none, // Không có đường viền
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14), // Khoảng cách giữa nội dung và viền
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 255, 255, 255)),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.all(16),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Clear filters",
                              style: TextStyle(
                                color: Color(0xFF008ABD),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF008ABD)),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.all(16),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Apply",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
