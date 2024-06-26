import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:studenthub/utils/toast.dart';

class SettingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final UserInfoStore _userInfoStore = Provider.of<UserInfoStore>(context);

    final currentConfig =
        GoRouter.of(context).routerDelegate.currentConfiguration;
    final currentPath = currentConfig.uri.toString();

    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.white,
        ),
        onPressed: () {
          routerConfig.push('/choose-user');
        },
      ),
      title: SizedBox(
        width: 160,
        height: MediaQuery.of(context).size.width * 0.2,
        child: Image.asset('assets/images/logo.png'),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      // elevation: 2,
      // shadowColor: Colors.black,
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      actions: [
        currentPath == "/choose-user"
            ? IconButton(
                onPressed: () {
                  if (!_userInfoStore.hasProfile) {
                    showDangerToast(
                        context: context,
                        message: "Please create a profile first.");

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
                  print(GoRouter.of(context)
                      .routerDelegate
                      .currentConfiguration
                      .uri
                      .toString());
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
