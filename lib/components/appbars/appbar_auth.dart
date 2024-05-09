import 'package:flutter/material.dart';
// ignore: camel_case_types
class Auth_AppBar extends StatelessWidget implements PreferredSizeWidget {
  const Auth_AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // ignore: sized_box_for_whitespace
      centerTitle: true,
      title: Container(
        width: 180,
        height: MediaQuery.of(context).size.width * 0.2,
        child: Image.asset(
          'assets/images/logo.png',
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      // elevation: 2,
      // shadowColor: Colors.black,
      iconTheme: Theme.of(context)
          .iconTheme
          .copyWith(color: Theme.of(context).colorScheme.primary), // actions: [
      //   IconButton(
      //     onPressed: () async {
      //       routerConfig.push('/');
      //     },
      //     icon: const Icon(
      //       Icons.arrow_forward_ios_rounded,
      //       color: Color(0xFF008ABD),
      //     ),
      //   ),
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
