import 'package:flutter_modular/flutter_modular.dart';

import '../core/core_module.dart';
import '../core/stores/auth_store.dart';
import 'splash_page.dart';

class SplashModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (context) => SplashPage(authStore: Modular.get<AuthStore>()),
    );
  }
}
