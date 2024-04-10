import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app_routes.dart';

// ignore: camel_case_types
class Auth_AppBar extends StatelessWidget implements PreferredSizeWidget {
  const Auth_AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // ignore: sized_box_for_whitespace
      title: Container(
        width: 160,
        height: MediaQuery.of(context).size.width * 0.2,
        child: Image.asset('assets/images/logo.png'),
      ),
      backgroundColor: const Color(0xFF008ABD),
      elevation: 2,
      shadowColor: Colors.black,
      leading: GoRouter.of(context).canPop()
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                GoRouter.of(context).pop();
              },
            )
          : null,
      // actions: [
      //   IconButton(
      //     onPressed: () async {
      //       routerConfig.push('/');
      //     },
      //     icon: const Icon(
      //       Icons.arrow_forward_ios_rounded,
      //       color: Colors.white,
      //     ),
      //   ),
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
