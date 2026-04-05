import 'package:google_sign_in/google_sign_in.dart';

import '../exceptions/sign_in_exception.dart';

class GoogleSignInService {
  GoogleSignInService() {
    _googleSignIn = GoogleSignIn.instance;
  }
  late final GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _user;
  GoogleSignInClientAuthorization? _authorization;
  final List<String> _scopes = ['https://www.googleapis.com/auth/spreadsheets'];

  Future<void> init() async {
    await _googleSignIn.initialize();
  }

  Future<bool> isUserLoggedIn() async {
    return _user != null;
  }

  Future<bool> signIn() async {
    try {
      // 1. Tenta o login rápido (silencioso) usando as credenciais já salvas no celular
      _user = await _googleSignIn.attemptLightweightAuthentication();

      // 2. Se não conseguiu silenciosamente, força a tela do Google
      if (_user == null) {
        // O SEGREDO: Limpa o cache de estado travado do Credential Manager antes de tentar
        await _googleSignIn.signOut();

        _user = await _googleSignIn.authenticate();
      }
    } on GoogleSignInException catch (e) {
      // Aqui você pode imprimir o erro no console para debugar melhor
      throw SignInException(e.description ?? 'Erro desconhecido ao logar');
    } catch (e) {
      throw SignInException(e.toString());
    }

    return _user != null;
  }

  Future<bool> checkGrantedScopes() async {
    _authorization = await _user?.authorizationClient.authorizationForScopes(
      _scopes,
    );
    _authorization ??= await _user?.authorizationClient.authorizeScopes(
      _scopes,
    );

    return _authorization != null;
  }

  String? getToken() {
    return _authorization?.accessToken;
  }
}
