import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String? _userID;
  String? _token;
  DateTime? _expireDate;

  bool get isAuthed {
    return token != null;
  }

  String? get userId {
    return _userID;
  }

  String? get token {
    if (_token != null &&
        _expireDate != null &&
        _expireDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> _authentication(
      String? email, String? password, String? accountSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$accountSegment?key=AIzaSyBdiSPxUKbokXQ0JbwCY_aY0JNAZsqbm5k";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]["message"].toString());
      }
      _token = responseData["idToken"];
      _userID = responseData["localId"];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData["expiresIn"],
          ),
        ),
      );
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final String userData = json.encode({
        "userId": _userID,
        "token": _token,
        "expireDate": _expireDate!.toIso8601String(),
      });
      await prefs.setString("userData", userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString("userData") as String) as Map;
    if (DateTime.parse(extractedUserData["expireDate"])
        .isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userID = extractedUserData['userId'];
    _expireDate = DateTime.parse(extractedUserData['expireDate']);
    notifyListeners();
    return true;
  }

  Future<void> signUp(String? email, String? password) async {
    return await _authentication(
      email,
      password,
      "signUp",
    );
  }

  Future<void> logIn(String? email, String? password) async {
    return await _authentication(
      email,
      password,
      "signInWithPassword",
    );
  }

  Future<void> logOut() async {
    _expireDate = null;
    _token = null;
    _userID = null;
    print(_userID);
    print(_token);
    print(_expireDate);
    notifyListeners();
    print("NotifyListners Done");
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove("userData");
    prefs.clear();
  }
}
