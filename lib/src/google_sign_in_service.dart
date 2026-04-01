import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  GoogleSignInService() {
    _googleSignIn = GoogleSignIn.instance;
  }
  late final GoogleSignIn _googleSignIn;
}
