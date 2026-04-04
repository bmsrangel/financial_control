import 'package:finance_control/src/exceptions/sign_in_exception.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  GoogleSignInService() {
    _googleSignIn = GoogleSignIn.instance;
  }
  late final GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _user;
  final List<String> _scopes = ['https://www.googleapis.com/auth/spreadsheets'];

  Future<void> init() async {
    await _googleSignIn.initialize();
  }

  Future<bool> isUserLoggedIn() async {
    return _user != null;
  }

  Future<bool> signIn() async {
    // _user = await _googleSignIn.attemptLightweightAuthentication();
    if (_user == null) {
      try {
        _user = await _googleSignIn.authenticate(scopeHint: _scopes);
        print(_user?.displayName ?? 'No display name');
      } on GoogleSignInException catch (e) {
        throw SignInException(e.description);
      }
    }
    return _user != null;
  }

  Future checkGrantedScopes() async {
    GoogleSignInClientAuthorization? authorization = await _user
        ?.authorizationClient
        .authorizationForScopes(_scopes);
    authorization ??= await _user?.authorizationClient.authorizeScopes(_scopes);

    return authorization != null;
  }
}
