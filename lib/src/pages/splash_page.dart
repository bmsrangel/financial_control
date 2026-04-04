import 'package:finance_control/src/auth/auth_store.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final AuthStore _authStore;

  // @override
  // void initState() {
  //   super.initState();
  //   _authStore = context.read<AuthStore>();
  //   _authStore.addListener(_isUserLoggedListener);
  //   _authStore.init().then((_) {
  //     _authStore.checkUserLogged().then((_) {
  //       if (!_authStore.isUserLogged) {
  //         _authStore.login();
  //       }
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   _authStore.removeListener(_isUserLoggedListener);
  //   super.dispose();
  // }

  // void _isUserLoggedListener() {
  //   if (_authStore.isUserLogged) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => MyHomePage(title: 'Home')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Splash')),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
