import 'package:flutter/material.dart';
import 'package:studenthub/app_routes.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Container(
        width: 160,
        height: MediaQuery.of(context).size.width * 0.2,
        child: Image.asset('assets/images/logo.png'),
      ),
      backgroundColor: const Color(0xFF008ABD),
      // elevation: 2,
      // shadowColor: Colors.black,
      actions: [
        IconButton(
          onPressed: () {
            routerConfig.push('/choose-user');
          },
          icon: const Icon(
            Icons.person,
            size: 30,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
