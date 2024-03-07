import 'package:provider/provider.dart';
import 'package:studenthub/stores/user_info/user_info.dart';

final appProviders = [
  //Providers for Mobx Store
  Provider<UserInfoStore>(create: (_) => UserInfoStore()),
  //Providers for ThemeData
];
