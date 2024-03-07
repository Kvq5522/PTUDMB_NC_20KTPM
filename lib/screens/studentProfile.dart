import 'package:flutter/material.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({Key? key}) : super(key: key);

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController schoolController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              // avatar
              Stack(
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                          image: AssetImage("assets/images/intro6.png")),
                    ),
                  ),
                  Positioned(
                    bottom: 22,
                    right: 22,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xFF00658a),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(99),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(99),
                          borderSide: const BorderSide(
                              color: Colors.grey), // Màu của đường viền
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'ID',
                        labelStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.featured_video_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(99),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(99),
                          borderSide: const BorderSide(
                              color: Colors.grey), // Màu của đường viền
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.mail),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(99),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(99),
                          borderSide: const BorderSide(
                              color: Colors.grey), // Màu của đường viền
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Phone No',
                        labelStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(99),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(99),
                          borderSide: const BorderSide(
                              color: Colors.grey), // Màu của đường viền
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF00658a),
                          backgroundColor: const Color(0xFF00658a),
                        ),
                        child: const Text(
                          "Edit Profie",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
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
