import 'package:flutter/foundation.dart';

import 'package:tipid/models/session.dart';
import 'package:tipid/models/user.dart';

class AuthenticationState with ChangeNotifier {
  AuthenticationState() {
    _authenticated = false;
  }

  AuthenticationState.authenticated() {
    _authenticated = true;
  }

  bool _authenticated;
  // ignore: unused_field
  String _authenticationToken = '';
  bool _loading = false;
  // ignore: unused_field
  User _user;

  bool get authenticated => _authenticated;
  bool get loading => _loading;

  void authenticationRequest() {
    _loading = true;
    notifyListeners();
  }

  void authenticationSuccess(Session session) {
    _authenticated = true;
    _authenticationToken = session.authenticationToken;
    _loading = false;
    _user = session.user;
    notifyListeners();
  }

  void authenticationFailure() {
    _loading = false;
    notifyListeners();
  }

  void signOutRequest() {
    _loading = true;
    notifyListeners();
  }

  void signOutSuccess() {
    _authenticated = false;
    _authenticationToken = '';
    _loading = false;
    _user = null;
    notifyListeners();
  }
}
