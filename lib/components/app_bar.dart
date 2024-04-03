import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/stores/user_info/user_info.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final UserInfoStore _userInfoStore = Provider.of<UserInfoStore>(context);

    final currentConfig =
        GoRouter.of(context).routerDelegate.currentConfiguration;
    final currentPath = currentConfig.uri.toString();

    return AppBar(
      title: SizedBox(
        width: 160,
        height: MediaQuery.of(context).size.width * 0.2,
        child: Image.asset('assets/images/logo.png'),
      ),
      backgroundColor: const Color(0xFF008ABD),
      // elevation: 2,
      // shadowColor: Colors.black,
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
      actions: [
        currentPath == "/choose-user"
            ? IconButton(
                onPressed: () {
                  if (!_userInfoStore.hasProfile) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please create a profile first.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(30),
                        duration: Duration(seconds: 1),
                      ),
                    );

                    return;
                  }

                  routerConfig.go('/dashboard');
                },
                icon: const Icon(
                  Icons.home,
                  size: 30,
                  color: Colors.white,
                ))
            : IconButton(
                onPressed: () {
                  routerConfig.go('/choose-user');
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
