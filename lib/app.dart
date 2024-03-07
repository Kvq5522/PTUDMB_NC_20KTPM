import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/app_providers.dart';

class MainApp extends StatelessWidget {
  final bool showHome;

  const MainApp({super.key, required this.showHome});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp.router(
        title: 'Student Hub',
        routerConfig: routerConfig,
      ),
    );
  }
}
