import 'package:mobx/mobx.dart';

part 'user_info.g.dart';

class UserInfoStore = _UserInfoStore with _$UserInfoStore;

abstract class _UserInfoStore with Store {
  @observable
  BigInt userId = BigInt.zero;

  @observable
  String username = '';

  @observable
  String email = '';

  @observable
  String userType = '';

  @observable
  bool hasProfile = false;

  @observable
  BigInt roleId = BigInt.zero;

  @observable
  String token = '';

  @action
  void setUserId(BigInt value) => userId = value;

  @action
  void setUsername(String value) => username = value;

  @action
  void setEmail(String value) => email = value;

  @action
  void setUserType(String value) => userType = value;

  @action
  void setHasProfile(bool value) => hasProfile = value;

  @action
  void setRoleId(BigInt value) => roleId = value;

  @action
  void setToken(String value) => token = value;

  @action
  void reset() {
    username = '';
    email = '';
    userType = '';
    hasProfile = false;
    roleId = BigInt.zero;
  }
}
