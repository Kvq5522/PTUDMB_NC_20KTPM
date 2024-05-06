import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/app_providers.dart';
import 'package:studenthub/themes/theme_provider.dart'; // Import your ThemeProvider class

class MainApp extends StatelessWidget {
  final bool showHome;

  const MainApp({Key? key, required this.showHome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...appProviders,
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) =>
              ThemeProvider(), // Provide an instance of ThemeProvider
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: 'Student Hub',
            routerConfig: routerConfig,
            theme: themeProvider.themeData,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale, // Use the theme data from ThemeProvider
          );
        },
      ),
    );
  }
}
