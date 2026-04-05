import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../core/stores/auth_store.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.authStore});

  final AuthStore authStore;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AuthStore get _authStore => widget.authStore;

  @override
  void initState() {
    super.initState();
    _authStore.addListener(_isUserLoggedListener);
    _authStore.init().then((_) {
      _authStore.checkUserLogged().then((_) {
        if (!_authStore.isUserLogged) {
          _authStore.login();
        }
      });
    });
  }

  @override
  void dispose() {
    _authStore.removeListener(_isUserLoggedListener);
    super.dispose();
  }

  void _isUserLoggedListener() {
    if (_authStore.isUserLogged) {
      Modular.to.navigate('/home/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Splash')),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
