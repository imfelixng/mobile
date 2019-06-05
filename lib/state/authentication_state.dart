import 'package:flutter/foundation.dart';

class AuthenticationState with ChangeNotifier {
  AuthenticationState() {
    _authenticated = false;
  }

  AuthenticationState.authenticated() {
    _authenticated = true;
  }

  bool _authenticated;
  bool _loading = false;

  bool get authenticated => _authenticated;
  bool get loading => _loading;

  void authenticationRequest() {
    _loading = true;
    notifyListeners();
  }

  void authenticationSuccess() {
    _authenticated = true;
    _loading = false;
    notifyListeners();
  }

  void signOutRequest() {
    _loading = true;
    notifyListeners();
  }

  void signOutSuccess() {
    _authenticated = false;
    _loading = false;
    notifyListeners();
  }
}
