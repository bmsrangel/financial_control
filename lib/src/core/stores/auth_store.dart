import 'package:flutter/material.dart';

import '../services/google_sign_in_service.dart';

class AuthStore extends ChangeNotifier {
  AuthStore(this._signInService);

  final GoogleSignInService _signInService;

  bool isUserLogged = false;

  Future<void> init() async {
    await _signInService.init();
  }

  Future<void> checkUserLogged() async {
    isUserLogged = await _signInService.isUserLoggedIn();
    notifyListeners();
  }

  Future<void> login() async {
    isUserLogged = await _signInService.signIn();
    await _signInService.checkGrantedScopes();
    notifyListeners();
  }

  String? getToken() {
    return _signInService.getToken();
  }
}
