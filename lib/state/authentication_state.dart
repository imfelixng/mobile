import 'package:flutter/foundation.dart';

class AuthenticationState with ChangeNotifier {
  bool _authenticated = false;
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
}
