import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';
import 'package:money_watcher/login/model/user_model.dart';

class AuthService {
  Future<bool> login(UserModel userModel) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error dating login: $e');
      }
      return false;
    }
  }

  Future signUp(UserModel userModel) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
    } catch (e) {
      rethrow;
    }
  }
}