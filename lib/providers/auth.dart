import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  late String token = '';
  late DateTime Expirydate;
  late String userid;

  bool get isauth {
    return token != '';
  }

  String? get gettoken {
    if (Expirydate != null &&
        Expirydate.isAfter(DateTime.now()) &&
        token != '') {
      return token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDmwARLYHhhrH78FOiUP4qwIgRz4piXqBM');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responsedata = json.decode(response.body);
      if (responsedata['error'] != null) {
        throw Httpexception(responsedata['error']['message']);
      }
      token = responsedata['idToken'];
      userid = responsedata['localId'];
      Expirydate = DateTime.now()
          .add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
  }

  Future<void> signup(String? email, String? password) async {
    return _authenticate(email!, password!, 'signUp');
  }

  Future<void> signin(String? email, String? password) async {
    return _authenticate(email!, password!, 'signInWithPassword');
  }
}
