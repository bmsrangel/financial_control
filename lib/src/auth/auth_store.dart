import 'package:finance_control/src/auth/google_sign_in_service.dart';
import 'package:flutter/material.dart';

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
    notifyListeners();
  }
}
