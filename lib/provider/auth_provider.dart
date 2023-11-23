import 'package:flutter/cupertino.dart';
import 'package:money_weather/model/user_model.dart';
import 'package:money_weather/service/database_service.dart';

class AuthProvider extends ChangeNotifier {
  DatabaseService databaseService;

  AuthProvider(this.databaseService);

  bool isVisible = false;
  bool isLoading = false;
  String? error;

  void setPasswordFieldStatus() {
    isVisible = !isVisible;
    notifyListeners();
  }

  Future registerUser(User user) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await databaseService.registerUser(user);
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> isUserExists(User user) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      return await databaseService.isUserExists(user);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return false;
  }
}