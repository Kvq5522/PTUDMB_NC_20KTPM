import 'package:mobx/mobx.dart';

part 'user_info.g.dart';

class UserInfoStore = _UserInfoStore with _$UserInfoStore;

abstract class _UserInfoStore with Store {
  @observable
  String username = '';

  @observable
  String email = '';

  @observable
  String userType = '';

  @action
  void setUsername(String value) => username = value;

  @action
  void setEmail(String value) => email = value;

  @action
  void setUserType(String value) => userType = value;
}
