import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  late String token = '';
  late DateTime Expirydate;
  late String userid;
  Timer? authtimer;

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

  String get userId {
    return userid;
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
      print(response.body);
      final responsedata = json.decode(response.body);
      if (responsedata['error'] != null) {
        print("error la labbe");
        throw Httpexception(responsedata['error']['message']);
      }
      token = responsedata['idToken'];
      userid = responsedata['localId'];

      Expirydate = DateTime.now()
          .add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      print('vachindhi');
      autologout();
      print("will it ");
      notifyListeners();
      print(1);
      final prefs = await SharedPreferences.getInstance();
      print(2);
      final userdata = json.encode({
        'token': token,
        'userid': userid,
        'expirydate': Expirydate.toIso8601String()
      });
      prefs.setString('userdata', userdata);
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

  Future<bool> tryautologin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return false;
    }
    final extracteduserdata = json.decode(prefs.getString('userdata')!) as Map;
    final gotexpirydate = DateTime.parse(extracteduserdata['expirydate']);
    if (gotexpirydate.isBefore(DateTime.now())) {
      return false;
    }
    token = extracteduserdata['token'];
    userid = extracteduserdata['userid'];
    Expirydate = gotexpirydate;
    notifyListeners();
    autologout();
    return true;
  }

  Future<void> logout() async {
    token = '';
    userid = '';
    Expirydate = DateTime.now();
    if (authtimer != null) {
      authtimer?.cancel();
      authtimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userdata')
    prefs.clear();
  }

  void autologout() {
    if (authtimer != null) {
      authtimer?.cancel();
    }
    final timetoexpiry = Expirydate.difference(DateTime.now()).inSeconds;
    authtimer = Timer(Duration(seconds: timetoexpiry), () => logout());
  }
}
