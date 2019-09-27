import 'package:flutter/foundation.dart';

abstract class IUserRepository {
  Future<String> authenticate({
    @required String username,
    @required String password,
  });

  Future<void> deleteToken();

  Future<void> persistToken(String token);

  Future<bool> hasToken();
}

class UserRepository implements IUserRepository {
  @override
  Future<String> authenticate({String username, String password}) async {
    await Future.delayed(Duration(seconds: 1));
    return 'token';
  }

  @override
  Future<void> deleteToken() async {
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  @override
  Future<bool> hasToken() async {
    await Future.delayed(Duration(seconds: 1));
    return false;
  }

  @override
  Future<void> persistToken(String token) async {
    await Future.delayed(Duration(seconds: 1));
    return;
  }
}
