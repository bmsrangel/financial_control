import 'package:finance_control/src/core/services/google_sign_in_service.dart';
import 'package:finance_control/src/core/stores/auth_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addLazySingleton(GoogleSignInService.new);
    i.addLazySingleton(AuthStore.new);
  }
}
