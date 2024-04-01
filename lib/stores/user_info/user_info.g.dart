// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserInfoStore on _UserInfoStore, Store {
  late final _$usernameAtom =
      Atom(name: '_UserInfoStore.username', context: context);

  @override
  String get username {
    _$usernameAtom.reportRead();
    return super.username;
  }

  @override
  set username(String value) {
    _$usernameAtom.reportWrite(value, super.username, () {
      super.username = value;
    });
  }

  late final _$emailAtom = Atom(name: '_UserInfoStore.email', context: context);

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$userTypeAtom =
      Atom(name: '_UserInfoStore.userType', context: context);

  @override
  String get userType {
    _$userTypeAtom.reportRead();
    return super.userType;
  }

  @override
  set userType(String value) {
    _$userTypeAtom.reportWrite(value, super.userType, () {
      super.userType = value;
    });
  }

  late final _$hasProfileAtom =
      Atom(name: '_UserInfoStore.hasProfile', context: context);

  @override
  bool get hasProfile {
    _$hasProfileAtom.reportRead();
    return super.hasProfile;
  }

  @override
  set hasProfile(bool value) {
    _$hasProfileAtom.reportWrite(value, super.hasProfile, () {
      super.hasProfile = value;
    });
  }

  late final _$roleIdAtom =
      Atom(name: '_UserInfoStore.roleId', context: context);

  @override
  BigInt get roleId {
    _$roleIdAtom.reportRead();
    return super.roleId;
  }

  @override
  set roleId(BigInt value) {
    _$roleIdAtom.reportWrite(value, super.roleId, () {
      super.roleId = value;
    });
  }

  late final _$tokenAtom = Atom(name: '_UserInfoStore.token', context: context);

  @override
  String get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$_UserInfoStoreActionController =
      ActionController(name: '_UserInfoStore', context: context);

  @override
  void setUsername(String value) {
    final _$actionInfo = _$_UserInfoStoreActionController.startAction(
        name: '_UserInfoStore.setUsername');
    try {
      return super.setUsername(value);
    } finally {
      _$_UserInfoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_UserInfoStoreActionController.startAction(
        name: '_UserInfoStore.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_UserInfoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserType(String value) {
    final _$actionInfo = _$_UserInfoStoreActionController.startAction(
        name: '_UserInfoStore.setUserType');
    try {
      return super.setUserType(value);
    } finally {
      _$_UserInfoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setHasProfile(bool value) {
    final _$actionInfo = _$_UserInfoStoreActionController.startAction(
        name: '_UserInfoStore.setHasProfile');
    try {
      return super.setHasProfile(value);
    } finally {
      _$_UserInfoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRoleId(BigInt value) {
    final _$actionInfo = _$_UserInfoStoreActionController.startAction(
        name: '_UserInfoStore.setRoleId');
    try {
      return super.setRoleId(value);
    } finally {
      _$_UserInfoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setToken(String value) {
    final _$actionInfo = _$_UserInfoStoreActionController.startAction(
        name: '_UserInfoStore.setToken');
    try {
      return super.setToken(value);
    } finally {
      _$_UserInfoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$_UserInfoStoreActionController.startAction(
        name: '_UserInfoStore.reset');
    try {
      return super.reset();
    } finally {
      _$_UserInfoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
username: ${username},
email: ${email},
userType: ${userType},
hasProfile: ${hasProfile},
roleId: ${roleId},
token: ${token}
    ''';
  }
}
